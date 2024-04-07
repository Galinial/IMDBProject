//
//  NetworkManager.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation
import Combine

class NetworkManager {
    
    private let baseURL = "https://api.themoviedb.org/3/"
    
    private let headersForGet = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OTc1MzdjZWMxYTdjMmI0Mjc1ZGVhZGMzY2U4ZjYxZCIsInN1YiI6IjY2MGRiNjEwYzhhNWFjMDE3YzdiNTkzZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BUh0kOkvviZABohQR8SqfB_hePepzsrjKaB46ahFhjc"
    ]
    
    private let headerForPost = [
        "accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OTc1MzdjZWMxYTdjMmI0Mjc1ZGVhZGMzY2U4ZjYxZCIsInN1YiI6IjY2MGRiNjEwYzhhNWFjMDE3YzdiNTkzZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.BUh0kOkvviZABohQR8SqfB_hePepzsrjKaB46ahFhjc"
    ]
    
    // MARK: GET Media Request
    
    func getMediaFor(endPoint: APIEndpoint) async throws -> ([MediaItem]) {
        return try await withCheckedThrowingContinuation { [weak self] continuation in
            var url = self?.baseURL ?? ""
            url += endPoint.description
            
            let request = NSMutableURLRequest(url: URL(string: url) ?? URL(fileURLWithPath: ""),
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 10.0)
            
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = self?.headersForGet
            
            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    if let jsonData = data {
                        do {
                            let decoder = JSONDecoder()
                            switch endPoint {
                            case .popularMovies, .trendingMovies, .nowPlayingMovies, .topRatedMovies, .favoriteMovies:
                                let movieResponse = try decoder.decode(MovieResponse.self, from: jsonData)
                                let mediaItems = movieResponse.results.map { MediaItem(backdropPath: $0.backdropPath, genreIds: $0.genreIds, id: $0.id, originalLanguage: $0.originalLanguage, overview: $0.overview, popularity: $0.popularity, posterPath: $0.posterPath, voteAverage: $0.voteAverage, voteCount: $0.voteCount, originalName: $0.originalTitle, mediaResult: .movie) }
                                continuation.resume(returning: mediaItems)
                            case .popularTVShows, .trendingTVShows, .topRatedTVShows, .favoriteTVShows:
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
    
    // MARK: GET Reviews Request
    
    func fetchReviews(mediaType: MediaType, mediaId: String) async throws -> [Review] {
        let url = URL(string: "https://api.themoviedb.org/3/\(mediaType.rawValue)/\(mediaId)/reviews?language=en-US&page=1")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headersForGet
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let reviewResponse = try decoder.decode(ReviewResponse.self, from: data)
        return reviewResponse.results
    }
    
    //MARK: POST Favorite MediaItem
    
    
    
    func addFavoriteItem(mediaItem: MediaItem, isFavorite: Bool) async throws -> HTTPURLResponse {
        
        let parameters = [
            "media_type": mediaItem.mediaResult.rawValue,
            "media_id": mediaItem.id.description,
            "favorite": isFavorite
        ] as [String : Any]
        
        let postData = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        guard let url = URL(string: "https://api.themoviedb.org/3/account/21182875/favorite") else {
            throw NSError(domain: "InvalidURL", code: 0, userInfo: nil)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headerForPost
        request.httpBody = postData as Data
        
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NSError(domain: "InvalidResponseError", code: 0, userInfo: nil)
        }
        
        return httpResponse
    }
    
}
