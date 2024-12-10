//
//  SortMethodTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
@testable import RickyBuggy


final class SortMethodTests: XCTestCase {
    
    struct Constants {
        struct SortTypes {
            static let name = "Name"
            static let episodeCount = "Episodes Count"
        }
    }
    
    func testSortMethodDescription() {
        
        XCTAssertEqual(SortMethod.name.description, Constants.SortTypes.name, "Expected description to match 'Name'")
        XCTAssertEqual(SortMethod.episodesCount.description, Constants.SortTypes.episodeCount, "Expected description to match 'Episodes Count'")
    }
    
    func testSortMethodSortingClosure() {
        let characters = [
            CharacterResponseModel.dummy,
            CharacterResponseModel(id: 2, name: "Morty", status: "Alive", species: "Human", type: "", gender: "Male", origin: .originDummy, location: .dummy, image: "https://rickandmortyapi.com/api/character/avatar/2.jpeg", episode: ["e1"], url: "https://rickandmortyapi.com/api/character/2", created: "2017-11-04T18:48:46.250Z"),
            CharacterResponseModel(id: 3, name: "Beth", status: "Alive", species: "Human", type: "", gender: "Female", origin: .originDummy, location: .dummy, image: "https://rickandmortyapi.com/api/character/avatar/3.jpeg", episode: ["e1", "e2", "e3"], url: "https://rickandmortyapi.com/api/character/3", created: "2017-11-04T18:48:46.250Z")
        ]
        
        let nameSortedCharacters = characters.sorted(by: SortMethod.name.sortingClosure)
        XCTAssertEqual(nameSortedCharacters.map { $0.name }, ["Beth", "Jhonny", "Morty"], "Expected characters to be sorted by name alphabetically")
        
        let episodesCountSortedCharacters = characters.sorted(by: SortMethod.episodesCount.sortingClosure)
        XCTAssertEqual(episodesCountSortedCharacters.map { $0.name }, ["Morty", "Jhonny", "Beth"], "Expected characters to be sorted by episodes count in ascending order")
    }
}
