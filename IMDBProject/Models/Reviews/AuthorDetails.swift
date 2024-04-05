//
//  AuthorDetails.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import Foundation

struct AuthorDetails: Codable, Equatable {
        let name: String
        let username: String
        let avatarPath: String?
        let rating: Int
}
