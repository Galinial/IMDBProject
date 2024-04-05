//
//  Review.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import Foundation

struct Review: Codable, Identifiable, Equatable {
        let author: String
        let authorDetails: AuthorDetails
        let content: String
        let createdAt: String
        let id: String
        let updatedAt: String
        let url: String
    
}
