//
//  NetworkManager.swift
//  RickyBuggy
//

import Foundation
import Combine

final class NetworkManager: NetworkManagerProtocol {
    
    /// FIX: 2 - Refactor - add support for different properties eg. POST, httpBody, different timeouts etc. -- DONE
    func publisher(path: String,
                   httpMethod: String,
                   httpBody: Data?,
                   timeoutInterval timeout: TimeInterval) -> Publishers.MapKeyPath<Publishers.MapError<URLSession.DataTaskPublisher, Error>, Data> {
        var components = URLComponents()
        components.scheme = Constants.NetworkConstants.scheme
        components.host = Int.random(in: 1...10) > 3 ? Constants.NetworkConstants.baseURL : Constants.NetworkConstants.failCaseURL
        components.path = path
        
        /// FIX: 3 - Add "guard let url = components.url else..." -- DONE
        /// Have not changed the return type in protocol so added dummy empty value for else
        guard let url = components.url else {
            return URLSession.shared.dataTaskPublisher(for: URLRequest(url: URL(string: Constants.NetworkConstants.failCaseURL)!))
                .mapError { _ in APIError.imageDataRequestFailed(underlyingError: URLError(.badURL)) }
                .map(\.data)
        }
        
        var request = URLRequest(url: url, timeoutInterval: timeout)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .map(\.data)
    }
    
    func publisher(fromURLString urlString: String) -> Publishers.MapError<Publishers.MapKeyPath<Publishers.FlatMap<URLSession.DataTaskPublisher, Publishers.ReceiveOn<Publishers.SetFailureType<Optional<URL>.Publisher, URLError>, DispatchQueue>>, Data>, Error> {
        return Just(urlString)
            .compactMap(URL.init)
            .setFailureType(to: URLError.self)
            .receive(on: DispatchQueue.main)
            .flatMap(URLSession.shared.dataTaskPublisher(for:))
            .map(\.data)
            .mapError { $0 as Error }
    }
}
