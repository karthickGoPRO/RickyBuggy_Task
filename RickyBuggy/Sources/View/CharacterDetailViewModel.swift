//
//  CharacterDetailViewModel.swift
//  RickyBuggy
//

import Combine
import Foundation

final class CharacterDetailViewModel: ObservableObject {
    @Published var showsLocationDetailsView = false

    @Published private(set) var data: (characterDetails: CharacterResponseModel, location: LocationDetailsResponseModel)?
    @Published private(set) var CharacterPhotoData: Data?
    @Published private(set) var characterErrors: [APIError] = []

    @Published private(set) var title: String = "-"
    @Published private(set) var popularityName: String = "-"
    @Published private(set) var url: String = "-"
    @Published private(set) var created: String = "-"
    
    @Published private(set) var details: String = "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat."
    
    private let showsLocationDetailsSubject = CurrentValueSubject<Bool?, Never>(nil)

    private let characterIDSubject = CurrentValueSubject<Int?, Never>(nil)
    private let dataSubject = CurrentValueSubject<(characterDetails: CharacterResponseModel, location: LocationDetailsResponseModel)?, Never>(nil)

    private var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    
    init(characterId: Int, name: String, imageURL : String = "") {
        self.title = name

        let apiService = SwiftInjectDI.shared.resolve(APIClient.self)
        let discCacheManager = DiskCacheManager()

        showsLocationDetailsSubject
            .compactMap { $0 }
            .removeDuplicates()
            .assign(to: \.showsLocationDetailsView, on: self)
            .store(in: &cancellables)

        let dataPublisher = dataSubject
            .compactMap { $0 }
            .share()

        let characterDetailsPublisher = dataPublisher
            .map(\.characterDetails)

        dataPublisher
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                if case let .failure(error) = completion {
                    self.characterErrors.append(.characterDetailRequestFailed(underlyingError: error))
                }
            }, receiveValue: { [weak self] characterDetail, location in
                guard let self = self else { return }
                self.data = (characterDetail, location)
            })
            .store(in: &cancellables)

        characterDetailsPublisher
            .map(\.image)
            .flatMap { imageURLString -> ImageDataPublisher in
                guard let apiService = apiService else {
                    return Empty().eraseToAnyPublisher()
                }
                return apiService.imageDataPublisher(fromURLString: imageURLString)
            }
            .replaceError(with: Data())
            .compactMap { $0 }
            .assign(to: \.CharacterPhotoData, on: self)
            .store(in: &cancellables)
        
        discCacheManager.imageDataSyncronizer(
            forKey: imageURL,
            cacheAvailable: { cachedData in
                self.CharacterPhotoData = cachedData
            },
            cacheNotAvailableHitAPI: { [weak self] in
                guard let self else { return }
                characterDetailsPublisher
                    .map(\.image)
                    .flatMap { imageURLString -> ImageDataPublisher in
                        guard let apiService = apiService else {
                            return Empty().eraseToAnyPublisher()
                        }
                        return apiService.imageDataPublisher(fromURLString: imageURLString)
                    }
                    .replaceError(with: Data())
                    .compactMap { $0 }
                    .assign(to: \.CharacterPhotoData, on: self)
                    .store(in: &self.cancellables)
            }
        )

        characterDetailsPublisher
            .map(\.name)
            .assign(to: \.title, on: self)
            .store(in: &cancellables)

        characterDetailsPublisher
            .map(\.episode)
            .map(\.count)
            .compactMap(AppearanceFrequency.init(count:))
            .map(\.popularity)
            .assign(to: \.popularityName, on: self)
            .store(in: &cancellables)
        
        characterDetailsPublisher
            .map(\.url)
            .removeDuplicates()
            .assign(to: \.url, on: self)
            .store(in: &cancellables)

        characterDetailsPublisher
            .map(\.created)
            .assign(to: \.created, on: self)
            .store(in: &cancellables)

        characterIDSubject.send(characterId)
    }
    
    // MARK: - Inputs

    func setShowsLocationDetails() {
        showsLocationDetailsSubject.send(true)
    }
    
    func requestData() {
        guard isLoading == false else { return }
        
        data = nil
        characterErrors.removeAll()
        isLoading = true
        
        if let apiService = SwiftInjectDI.shared.resolve(APIClient.self),
           let characterID = characterIDSubject.value {
            Publishers.Zip(
                apiService.characterDetailPublisher(with: String(characterID)),
                apiService.locationPublisher(with: "\(characterID)")
            )
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                    case let .failure(error):
                        self.characterErrors.append(error)
                    case .finished:
                        break
                }
                self.isLoading = false
            }, receiveValue: { [weak self] characterDetail, comments in
                guard let self = self else { return }
                self.dataSubject.send((characterDetail, comments))
            })
            .store(in: &cancellables)
        }
    }
}
