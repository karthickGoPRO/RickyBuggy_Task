//
//  APIService.swift
//  RickyBuggy
//

import Foundation
import Combine

final class APIClient: APIProtocol {
    private let networkManager: NetworkManagerProtocol?
    
    init() {
        self.networkManager = DIContainer.shared.resolve(NetworkManager.self)
    }
    
    func imageDataPublisher(fromURLString urlString: String) -> ImageDataPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }
        
        return Just(urlString)
            .setFailureType(to: Error.self)
            .flatMap { path in
                networkManager.publisher(fromURLString: path)
                    .handleEvents(receiveOutput: { [weak self] receivedData in
                    guard let _ = self else { return }
                    do {
                        let discCacheManager = DIContainer.shared.resolve(DiskCacheManager.self)
                        try discCacheManager?.storeImageData(receivedData, forKey: urlString)
                    } catch {
                        print("Failed to store image data: \(error)")
                    }
                })
            }.handleEvents(receiveCompletion: { completion in
                switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Network request failed with error: \(error)")
                }
            })
            .mapError { error in
                APIError.imageDataRequestFailed(underlyingError: error)
            }
            .eraseToAnyPublisher()
    }
    
    func charactersPublisher() -> CharactersPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }

        return Just(Constants.URLBuilder(type: .characters, value: "/\(Array(1...20))"))
            .setFailureType(to: Error.self)
            .flatMap { path in
                networkManager.publisher(path: path)
            }
            .decode(type: [CharacterResponseModel].self, decoder: JSONDecoder())
            .mapError { error in
                debugPrint(error)
                return APIError.charactersRequestFailed(underlyingError: error)
            }
            .eraseToAnyPublisher()
    }
    
    func characterDetailPublisher(with id: String) -> CharacterDetailsPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }

        return Just(Constants.URLBuilder(type: .characters, value: "/\(id)"))
            .setFailureType(to: Error.self)
            .flatMap { path in
                networkManager.publisher(path: path)
            }
            .decode(type: CharacterResponseModel.self, decoder: JSONDecoder())
            .mapError { error in
                debugPrint(error)
                return APIError.characterDetailRequestFailed(underlyingError: error)
            }
            .eraseToAnyPublisher()
    }
    
    func locationPublisher(with id: String) -> LocationPublisher {
        guard let networkManager = networkManager else { return Empty().eraseToAnyPublisher() }

        return Just(Constants.URLBuilder(type: .locations, value: "/\(id)"))
            .setFailureType(to: Error.self)
            .flatMap { path in
                networkManager.publisher(path: path)
            }
            .decode(type: LocationDetailsResponseModel.self, decoder: JSONDecoder())
            .mapError { error in
                debugPrint(error)
                return APIError.locationRequestFailed(underlyingError: error)
            }
            .eraseToAnyPublisher()
    }
}
