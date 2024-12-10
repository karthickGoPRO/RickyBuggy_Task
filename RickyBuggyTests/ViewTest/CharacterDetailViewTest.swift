//
//  CharacterDetailViewTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import RickyBuggy

class CharacterDetailViewTests: XCTestCase {
    
    var viewModel: CharacterDetailViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = CharacterDetailViewModel(characterId: 1, name: "Johnny")
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    func testCharacterDetailViewDisplaysProgressViewWhenLoading() throws {
        let view = CharacterDetailView(viewModel: viewModel)
        
        let progressView = try view.inspect().find(ViewType.ProgressView.self)
        XCTAssertNotNil(progressView, "The CharacterDetailView should display a ProgressView when loading.")
    }
}
