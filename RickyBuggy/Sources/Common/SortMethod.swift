//
//  SortMethod.swift
//  RickyBuggy
//

// FIX: 5 - Fix sorting, so it works - and sorts downloaded characters - DONE
enum SortMethod: Int {
    case name
    case episodesCount
}

extension SortMethod: CustomStringConvertible {
    var description: String {
        switch self {
        case .name:
            return "Name"
        case .episodesCount:
            return "Episodes Count"
        }
    }
}

extension SortMethod {
    var sortingClosure: (CharacterResponseModel, CharacterResponseModel) -> Bool {
        switch self {
            case .name:
                return { $0.name < $1.name }
            case .episodesCount:
                return { $0.episode.count > $1.episode.count }
        }
    }
}
