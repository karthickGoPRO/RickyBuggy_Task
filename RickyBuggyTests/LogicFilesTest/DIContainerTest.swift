//
//  DIContainerTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
@testable import RickyBuggy


class ExampleService {
    func sayHello() -> String {
        return "Hello, world!"
    }
}

final class DIContainerTests: XCTestCase {
    
    func testRegisterAndResolve() {
        let exampleService = ExampleService()
        
        DIContainer.shared.register(exampleService)
        
        let resolvedService: ExampleService? = DIContainer.shared.resolve(ExampleService.self)
        XCTAssertNotNil(resolvedService, "Expected resolved service to be non-nil")
        
        XCTAssertEqual(resolvedService?.sayHello(), "Hello, world!", "Expected 'sayHello' to return 'Hello, world!'")
    }
    
    func testDuplicateRegistration() {
        
        let firstInstance = ExampleService()
        let secondInstance = ExampleService()
    
        DIContainer.shared.register(firstInstance)
        
        DIContainer.shared.register(secondInstance)
        
        let resolvedService: ExampleService? = DIContainer.shared.resolve(ExampleService.self)
        XCTAssertNotNil(resolvedService, "Expected resolved service to be non-nil")
        XCTAssertEqual(resolvedService?.sayHello(), "Hello, world!", "Expected 'sayHello' to return 'Hello, world!'")
    }
    
    func testResolveNonRegisteredDependency() {
        let resolvedService: ExampleService? = DIContainer.shared.resolve(ExampleService.self)
        
        XCTAssertNoThrow(resolvedService)
    }
}
