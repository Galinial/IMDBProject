//
//  MovieResponse.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation

struct MovieResponse: Codable, Equatable {
    let page: Int
    let results: [Movie]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
