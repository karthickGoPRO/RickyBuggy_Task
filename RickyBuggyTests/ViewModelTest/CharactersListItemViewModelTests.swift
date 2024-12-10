//
//  CharactersListItemViewModel.swift
//  RickyBuggyTests
//

import Combine
import XCTest

@testable import RickyBuggy

final class CharactersListItemViewModelTests: XCTestCase {
    private var sut: CharactersListItemViewModel!
    
    override func setUp() {
        super.setUp()
        sut = CharactersListItemViewModel(character: .dummy)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
