//
//  SwiftUntitled.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import Swinject

final class SwiftInjectDI {
    static let shared = SwiftInjectDI()
    private let container: Container
    
    private init() {
        self.container = Container()
    }
    
    func register<Dependency>(_ dependencyType: Dependency.Type, factory: @escaping (Resolver) -> Dependency) {
        container.register(dependencyType, factory: factory)
    }
    
    func resolve<Dependency>(_ dependencyType: Dependency.Type) -> Dependency? {
        return container.resolve(dependencyType)
    }
}
