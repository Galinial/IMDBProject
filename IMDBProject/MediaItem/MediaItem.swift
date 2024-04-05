//
//  MediaItem.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation

struct MediaItem: Equatable, Identifiable {
    var backdropPath: String?
    var genreIds: [Int]
    var id: Int
    var originalLanguage: String
    var overview: String
    var popularity: Double
    var posterPath: String?
    var voteAverage: Double
    var voteCount: Int
    var originalName: String
    var mediaResult: MediaType
}
