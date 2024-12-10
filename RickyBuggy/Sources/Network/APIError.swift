//
//  APIError.swift
//  RickyBuggy
//

import Foundation

struct IdentifiableAPIError: Identifiable {
    let id = UUID()
    let error: APIError
}

/// FIX: 1 - Refactor so it accepts and displays underlaying error - DONE
enum APIError: Error {
    case imageDataRequestFailed(underlyingError: Error?)
    case charactersRequestFailed(underlyingError: Error?)
    case characterDetailRequestFailed(underlyingError: Error?)
    case locationRequestFailed(underlyingError: Error?)
}

extension APIError: LocalizedError {
    var localizedDescription: String {
        switch self {
            case .imageDataRequestFailed(let underlyingError):
                return "\(Constants.APIError.downloadFailed) \(underlyingErrorDescription(underlyingError))"
            case .charactersRequestFailed(let underlyingError):
                return "\(Constants.APIError.charFetchFailed) \(underlyingErrorDescription(underlyingError))"
            case .characterDetailRequestFailed(let underlyingError):
                return "\(Constants.APIError.charDetailesFailed) \(underlyingErrorDescription(underlyingError))"
            case .locationRequestFailed(let underlyingError):
                return "\(Constants.APIError.locationDetailesFailed) \(underlyingErrorDescription(underlyingError))"
        }
    }
    
    private func underlyingErrorDescription(_ error: Error?) -> String {
        guard let error = error else { return "" }
        return "\(Constants.APIError.errorTitle) \(error.localizedDescription)"
    }
}
