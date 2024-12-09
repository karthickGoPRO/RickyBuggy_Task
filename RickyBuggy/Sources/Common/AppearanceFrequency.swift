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
            case 10...: // If count is 10 or more
                self = .high
            case 3..<10: // If count is between 3 and 9 (inclusive)
                self = .medium
            default: // If count is less than 3
                self = .low
        }
    }
    
    var popularity: String {
        switch self {
            case .high:
                return "So popular!"
            case .medium:
                return "Kind of popular"
            case .low:
                return "Meh"
        }
    }
}
