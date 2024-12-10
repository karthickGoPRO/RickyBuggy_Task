//
//  CharacterListItemView.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import RickyBuggy

class CharactersListItemViewTests: XCTestCase {
    
    func testCharactersListItemViewDisplaysTitle() throws {
        let viewModel = CharactersListItemViewModel(character: .dummy)
        let view = CharactersListItemView(viewModel: viewModel)
        
        let text = try view.inspect().find(text: viewModel.title)
        
        XCTAssertEqual(try text.string(), viewModel.title, "The title should be displayed correctly.")
    }
    
    func testCharactersListItemViewDisplaysEpisodeCount() throws {
        let viewModel = CharactersListItemViewModel(character: .dummy)
        let view = CharactersListItemView(viewModel: viewModel)
        
        let text = try view.inspect().find(text: "\(Constants.UiConstants.episodeCountTitle) \(viewModel.countEPISODE)")
        
        XCTAssertEqual(try text.string(), "\(Constants.UiConstants.episodeCountTitle) \(viewModel.countEPISODE)", "The episode count should be displayed correctly.")
    }
    
    func testCharactersListItemViewDisplaysCharacterImage() throws {
        let viewModel = CharactersListItemViewModel(character: .dummy)
        let view = CharactersListItemView(viewModel: viewModel)
    
        let characterPhoto = try view.inspect().find(CharacterPhoto.self)
        
        XCTAssertNotNil(characterPhoto)
    }
}
