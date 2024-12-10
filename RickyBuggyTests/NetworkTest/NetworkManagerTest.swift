//
//  NetworkManagerTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
import Combine
@testable import RickyBuggy

class NetworkManagerTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    private var networkManager: NetworkManager!
    private var mockSession: URLSession!
    
    override func setUp() {
        super.setUp()
        mockSession = URLSession.mockSession(using: MockURLProtocol.self)
        networkManager = NetworkManager() // Inject the mocked session if required
    }
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func testPublisherPathMethodSuccess() {
        let expectedData = Data("Test response".utf8)
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.path, Constants.ClientPathAppender.characters.rawValue)
            XCTAssertEqual(request.httpMethod, "GET")
            XCTAssertEqual(request.httpBody, Data("Test body".utf8))
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, expectedData)
        }
        
        let expectation = XCTestExpectation(description: "Response received")
        networkManager.publisher(path: Constants.URLBuilder(type: .characters, value: "/\(Array(1...20))"))
        .sink(receiveCompletion: { completion in
            if case .failure(let returnData) = completion {
                XCTAssertNotNil(returnData)
            }
            expectation.fulfill()
        }, receiveValue: { data in
            XCTAssertNotNil(data)
            expectation.fulfill()
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testPublisherPathMethodFailure() {
        MockURLProtocol.requestHandler = { _ in
            throw URLError(.timedOut)
        }
        
        let expectation = XCTestExpectation(description: "Error received")
        networkManager.publisher(path: "",
                                 httpMethod: "PATCH",
                                 httpBody: nil,
                                 timeoutInterval: 5)
        .sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                XCTAssertNotNil(error, "Expected error, but got nil.")
                expectation.fulfill()
            }
        }, receiveValue: { _ in
            XCTFail("Expected failure, but got success.")
        })
        .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testPublisherFromURLStringSuccess() {
        let expectedData = Data("URL response".utf8)
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url?.absoluteString, "https://example.com")
            return (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: nil, headerFields: nil)!, expectedData)
        }
        
        let expectation = XCTestExpectation(description: "Response received")
        networkManager.publisher(fromURLString: "https://example.com")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("Expected success, but got failure: \(error)")
                }
            }, receiveValue: { data in
                XCTAssertNotNil(data)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 10)
    }
    
    func testPublisherFromURLStringInvalidURL() {
        let expectation = XCTestExpectation(description: "Error received")
        networkManager.publisher(fromURLString: "invalid_url")
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertTrue(error is URLError, "Expected URLError, but got \(error).")
                    expectation.fulfill()
                }
            }, receiveValue: { _ in
                XCTFail("Expected failure, but got success.")
            })
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
