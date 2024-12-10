//
//  AppearanceFrequencyTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
@testable import RickyBuggy

final class AppearanceFrequencyTests: XCTestCase {
    
    func testAppearanceFrequencyInitialization() {
        XCTAssertEqual(AppearanceFrequency(count: 10), .high, "Expected 'high' for count 10 or more")
        XCTAssertEqual(AppearanceFrequency(count: 15), .high, "Expected 'high' for count 15")
        
        XCTAssertEqual(AppearanceFrequency(count: 3), .medium, "Expected 'medium' for count 3 to 9")
        XCTAssertEqual(AppearanceFrequency(count: 5), .medium, "Expected 'medium' for count 5")
        XCTAssertEqual(AppearanceFrequency(count: 9), .medium, "Expected 'medium' for count 9")
        
        XCTAssertEqual(AppearanceFrequency(count: 0), .low, "Expected 'low' for count 0")
        XCTAssertEqual(AppearanceFrequency(count: 1), .low, "Expected 'low' for count 1")
        XCTAssertEqual(AppearanceFrequency(count: 2), .low, "Expected 'low' for count 2")
    }
    
    func testAppearanceFrequencyPopularity() {
        
        XCTAssertEqual(AppearanceFrequency.high.popularity, Constants.UiConstants.popularityIndexHigh)
        XCTAssertEqual(AppearanceFrequency.medium.popularity, Constants.UiConstants.popularityIndexMedium)
        XCTAssertEqual(AppearanceFrequency.low.popularity, Constants.UiConstants.popularityIndexLow)
    }
}
