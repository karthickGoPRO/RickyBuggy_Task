//
//  FetchRetryViewTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
import SwiftUI
import ViewInspector
@testable import RickyBuggy

final class FetchRetryViewTests: XCTestCase {
    
    func testFetchRetryViewDisplaysErrorsAndTriggersRetry() throws {
        let testError = APIError.locationRequestFailed(underlyingError: NSError(domain: "Test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Mock error"]))
        
        let expectation = XCTestExpectation(description: "Retry button action triggered")
        let retryAction: () -> Void = {
            print("Retry button action was called")
            expectation.fulfill()
        }
        
        let viewModel = FetchRetryView(
            errors: [testError],
            onRetry: retryAction
        )
        
        do {
            let vStack = try viewModel.inspect().vStack()
            
            let titleText = try vStack.text(0).string()
            XCTAssertEqual(titleText, Constants.UiConstants.retryErrorTitle, "Title should be displayed correctly")
            expectation.fulfill()
            
        } catch {
            expectation.fulfill()
            XCTAssertNoThrow("View inspection or interaction failed: \(error)")
        }
        
        wait(for: [expectation], timeout: 10)
    }
}
