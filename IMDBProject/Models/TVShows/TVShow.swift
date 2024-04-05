//
//  TVShow.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation

struct TVShow: Codable, Equatable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let id: Int
    let name: String
    let originalLanguage: String
    let originalName: String
    let overview: String
    let posterPath: String?
    let genreIds: [Int]
    let popularity: Double
    let firstAirDate: String
    let voteAverage: Double
    let voteCount: Int
    let originCountry: [String]
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case id
        case name
        case originalLanguage = "original_language"
        case originalName = "original_name"
        case overview
        case posterPath = "poster_path"
        case genreIds = "genre_ids"
        case popularity
        case firstAirDate = "first_air_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case originCountry = "origin_country"
    }
}
