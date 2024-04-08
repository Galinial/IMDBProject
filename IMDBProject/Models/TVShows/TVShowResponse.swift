//
//  TVShowResponse.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//
import Foundation

struct TVShowResponse: Codable {
    let page: Int
    let results: [TVShow]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
