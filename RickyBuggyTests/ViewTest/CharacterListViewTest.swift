//
//  CharacterListViewTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import RickyBuggy

class CharactersListViewTests: XCTestCase {
    
    func testCharactersListViewDisplaysCorrectNumberOfItems() throws {
        let characters = [CharacterResponseModel.dummy]
        let sortMethod: SortMethod = .name
        
        let view = CharactersListView(characters: .constant(characters), sortMethod: .constant(sortMethod))
        
        let list = try view.inspect().find(ViewType.List.self)

        XCTAssertNotNil(list)
    }
    
    func testCharacterListItemViewIsDisplayed() throws {
        let characters = [CharacterResponseModel.dummy]
        let sortMethod: SortMethod = .name
        
        let view = CharactersListView(characters: .constant(characters), sortMethod: .constant(sortMethod))
        
        let listItem = try view.inspect().find(CharactersListItemView.self)
        
        XCTAssertNotNil(listItem, "The CharactersListItemView should be present in the list.")
    }
}
