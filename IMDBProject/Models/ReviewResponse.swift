//
//  ReviewResponse.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import Foundation

struct ReviewResponse: Codable, Equatable {
    let id: Int
    let page: Int
    let results: [Review]
    let totalPages: Int
    let totalResults: Int
}
