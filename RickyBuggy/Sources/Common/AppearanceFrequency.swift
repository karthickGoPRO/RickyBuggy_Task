//
//  AppearanceFrequency.swift
//  RickyBuggy
//

import Foundation


/// Level selected based on number of appearances in the show, if character appeared 10 times or more - it's high, if 3 times or more - its medium, if 1 or lower - it's low
enum AppearanceFrequency: Int {
    case high = 10
    case medium = 3
    case low = 1
}

/// FIX: 4 - Fix issue with initialisation not working accordingly to requirements written above, try improving clean code approach

extension AppearanceFrequency {
    init(count: Int) {
        switch count {
            case 10...:
                self = .high
            case 3..<10:
                self = .medium
            default:
                self = .low
        }
    }
    
    var popularity: String {
        switch self {
            case .high:
                return Constants.UiConstants.popularityIndexHigh
            case .medium:
                return Constants.UiConstants.popularityIndexMedium
            case .low:
                return Constants.UiConstants.popularityIndexLow
        }
    }
}
