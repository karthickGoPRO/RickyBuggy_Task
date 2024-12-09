//
//  Constants.swift
//  RickyBuggy
//
//  Created by Karthick Thavasimuthu on 09/12/24.
//

import Foundation

struct Constants {
    
    enum APIError: String {
        case downloadFailed = "Could not download image."
        case charFetchFailed = "Could not fetch characters."
        case charDetailesFailed = "Could not get details of character."
        case locationDetailesFailed = "Could not get details of location."
        case errorTitle = "Underlying error:"
    }
    
    enum ClientPathAppender: String {
        case characters = "/api/character"
        case locations = "/api/location"
        case episodes = "/api/episode"
    }
    
    struct NetworkConstants {
        static let failCaseURL = "thisshouldfail.com"
        static let scheme = "https"
        static let baseURL = "rickandmortyapi.com"
        static let defaultMethod = "GET"
        static let defaultTimeout: TimeInterval = 10
    }
    
    struct UiConstants {
        static let sortingOptionTitle = "Choose Sorting"
        static let popularityIndexHigh = "So popular!"
        static let popularityIndexMedium = "Kind of popular"
        static let popularityIndexLow = "Meh"
        static let homepageTitle = "Characters"
        static let cancelTitle = "Cancel"
        static let sortingChoosingTitle = "Choose Sort"
        static let sortDescTitle = "Choose kind of sort - Episode Count descening order & Name Alphabatical"
        static let sortTitle = "Sorting"
        static let popularityTitle = "Popularity level : "
        static let about = "About"
        static let location = "Location"
        static let retryErrorTitle = "Retry Error"
        static let retryTitle = "Retry"
        static let episodeCountTitle = "Episodes - "
    }
    
    struct SortTypes {
        static let name = "Name"
        static let episodeCount = "Episodes Count"
    }
    
    static func URLBuilder(type : ClientPathAppender, value: String) -> String {
        return type.rawValue + value
    }
}
