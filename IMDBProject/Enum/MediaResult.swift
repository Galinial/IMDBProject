//
//  MediaResult.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation

enum MediaResult: Equatable, Identifiable {
    case movies([Movie])
    case tvShows([TVShow])
    
    var id: Int {
            switch self {
            case .movies(let movies):
                return movies.first?.id ?? 0
            case .tvShows(let tvShows):
                return tvShows.first?.id ?? 0
            }
        }
}
