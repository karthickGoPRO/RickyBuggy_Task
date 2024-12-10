//
//  APIErrorTest.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 10/12/24.
//

import XCTest
@testable import RickyBuggy

class APIErrorTests: XCTestCase {
    
    func testLocalizedDescriptionWithoutUnderlyingError() {
        let errors: [APIError] = [
            .imageDataRequestFailed(underlyingError: nil),
            .charactersRequestFailed(underlyingError: nil),
            .characterDetailRequestFailed(underlyingError: nil),
            .locationRequestFailed(underlyingError: nil)
        ]
        
        let expectedMessages = [
            "\(Constants.APIError.downloadFailed) ",
            "\(Constants.APIError.charFetchFailed) ",
            "\(Constants.APIError.charDetailesFailed) ",
            "\(Constants.APIError.locationDetailesFailed) "
        ]
        
        for (index, error) in errors.enumerated() {
            XCTAssertEqual(error.localizedDescription, expectedMessages[index], "Localized description does not match for error \(error)")
        }
    }
    
    func testLocalizedDescriptionWithUnderlyingError() {
        let underlyingError = NSError(domain: "TestDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Network failure"])
        let errors: [APIError] = [
            .imageDataRequestFailed(underlyingError: underlyingError),
            .charactersRequestFailed(underlyingError: underlyingError),
            .characterDetailRequestFailed(underlyingError: underlyingError),
            .locationRequestFailed(underlyingError: underlyingError)
        ]
        
        let expectedMessages = [
            "\(Constants.APIError.downloadFailed) \(Constants.APIError.errorTitle) \(underlyingError.localizedDescription)",
            "\(Constants.APIError.charFetchFailed) \(Constants.APIError.errorTitle) \(underlyingError.localizedDescription)",
            "\(Constants.APIError.charDetailesFailed) \(Constants.APIError.errorTitle) \(underlyingError.localizedDescription)",
            "\(Constants.APIError.locationDetailesFailed) \(Constants.APIError.errorTitle) \(underlyingError.localizedDescription)"
        ]
        
        for (index, error) in errors.enumerated() {
            XCTAssertEqual(error.localizedDescription, expectedMessages[index], "Localized description does not match for error \(error) with underlying error")
        }
    }
    
    func testIdentifiableAPIError() {
        let apiError = APIError.imageDataRequestFailed(underlyingError: nil)
        let identifiableError = IdentifiableAPIError(error: apiError)
        
        XCTAssertEqual(identifiableError.error.localizedDescription, apiError.localizedDescription, "Localized description does not match between IdentifiableAPIError and APIError")
        XCTAssertNotNil(identifiableError.id, "IdentifiableAPIError ID should not be nil")
    }
}
