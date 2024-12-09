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
    
    static func URLBuilder(type : ClientPathAppender, value: String) -> String {
        return type.rawValue + value
    }
}
