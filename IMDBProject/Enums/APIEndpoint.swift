//
//  APIEndpoint.swift
//  IMDBProject
//
//  Created by gal linial on 07/04/2024.
//

import Foundation

enum APIEndpoint: CustomStringConvertible {
    case popularMovies
    case popularTVShows
    case trendingMovies
    case trendingTVShows
    case topRatedMovies
    case topRatedTVShows
    case nowPlayingMovies
    case favoriteMovies
    case favoriteTVShows

    var description: String {
        switch self {
        case .popularMovies:
            return "movie/popular?language=en-US&page=1"
        case .popularTVShows:
            return "tv/popular?language=en-US&page=1"
        case .trendingMovies:
            return "trending/movie/day?language=en-US"
        case .trendingTVShows:
            return "trending/tv/day?language=en-US"
        case .topRatedMovies:
            return "movie/top_rated?language=en-US&page=1"
        case .topRatedTVShows:
            return "tv/top_rated?language=en-US&page=1"
        case .nowPlayingMovies:
            return "movie/now_playing?language=en-US&page=1"
        case .favoriteMovies:
            return "account/21182875/favorite/movies?language=en-US&page=1&sort_by=created_at.asc"
        case .favoriteTVShows:
            return "account/21182875/favorite/tv?language=en-US&page=1&sort_by=created_at.asc"
        }
    }
}
