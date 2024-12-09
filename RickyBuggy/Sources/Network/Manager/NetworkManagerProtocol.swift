//
//  NetworkManagerProtocol.swift
//  RickyBuggy
//

import Foundation
import Combine

/// Have not changed the return value used the provided one. (-> AnyPublisher<Data, Error> This is the generic way and adviseable)
protocol NetworkManagerProtocol {
    func publisher(path: String, httpMethod: String, httpBody: Data?, timeoutInterval: TimeInterval) -> Publishers.MapKeyPath<Publishers.MapError<URLSession.DataTaskPublisher, Error>, Data>
    func publisher(fromURLString urlString: String) -> Publishers.MapError<Publishers.MapKeyPath<Publishers.FlatMap<URLSession.DataTaskPublisher, Publishers.ReceiveOn<Publishers.SetFailureType<Optional<URL>.Publisher, URLError>, DispatchQueue>>, Data>, Error>
}

/// Added Extension to add default values to the protocol
extension NetworkManagerProtocol {
    func publisher(
        path: String,
        httpMethod: String = "GET",
        httpBody: Data? = nil,
        timeoutInterval: TimeInterval = 5
    ) -> Publishers.MapKeyPath<Publishers.MapError<URLSession.DataTaskPublisher, Error>, Data> {
        return publisher(path: path, httpMethod: httpMethod, httpBody: httpBody, timeoutInterval: 5)
    }
}
