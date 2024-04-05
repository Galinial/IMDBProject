//
//  NetworkManager.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation
import Combine

class NetworkManager {
    
    private let imageDownloadBaseURL = "https://image.tmdb.org/t/p/original"
    private let baseURL = "https://api.themoviedb.org/3/"
    
    private let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OTc1MzdjZWMxYTdjMmI0Mjc1ZGVhZGMzY2U4ZjYxZCIsInN1YiI6IjY2MGRiNjEwYzhhNWFjMDE3YzdiNTkzZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BUh0kOkvviZABohQR8SqfB_hePepzsrjKaB46ahFhjc"
    ]
    
    enum getURLExtension: String {
        case popularMovies = "movie/popular?language=en-US&page=1"
        case popularTVShows = "tv/popular?language=en-US&page=1"
        case trendingMovies = "trending/movie/day?language=en-US"
        case trendingTVShows = "trending/tv/day?language=en-US"
    }
    
    // MARK: GET Media Request
    func getMediaFor(urlExtension: getURLExtension) async throws -> [MediaItem] {
        return try await withCheckedThrowingContinuation { continuation in
            var url = baseURL
            url += urlExtension.rawValue
            
            let request = NSMutableURLRequest(url: URL(string: url) ?? URL(fileURLWithPath: ""),
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = self.headers
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    if let jsonData = data {
                        do {
                            let decoder = JSONDecoder()
                            switch urlExtension {
                            case .popularMovies, .trendingMovies:
                                let movieResponse = try decoder.decode(MovieResponse.self, from: jsonData)
                                let mediaItems = movieResponse.results.map { MediaItem(backdropPath: $0.backdropPath, genreIds: $0.genreIds, id: $0.id, originalLanguage: $0.originalLanguage, overview: $0.overview, popularity: $0.popularity, posterPath: $0.posterPath, voteAverage: $0.voteAverage, voteCount: $0.voteCount, originalName: $0.originalTitle, mediaResult: .movie) }
                                continuation.resume(returning: mediaItems)
                            case .popularTVShows, .trendingTVShows:
                                let tvShowResponse = try decoder.decode(TVShowResponse.self, from: jsonData)
                                let mediaItems = tvShowResponse.results.map { MediaItem(backdropPath: $0.backdropPath, genreIds: $0.genreIds, id: $0.id, originalLanguage: $0.originalLanguage, overview: $0.overview, popularity: $0.popularity, posterPath: $0.posterPath, voteAverage: $0.voteAverage, voteCount: $0.voteCount, originalName: $0.originalName, mediaResult: .tvShow) }
                                continuation.resume(returning: mediaItems)
                            }
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
            dataTask.resume()
        }
    }
    
    func fetchReviews() async throws -> [Review] {
        let url = URL(string: "https://api.themoviedb.org/3/movie/823464/reviews?language=en-US&page=1")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase // Set key decoding strategy
        
        let reviewResponse = try decoder.decode(ReviewResponse.self, from: data)
        return reviewResponse.results
    }
}
