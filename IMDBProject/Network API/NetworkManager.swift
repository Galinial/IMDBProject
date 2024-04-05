//
//  NetworkManager.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation

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
    func getMediaFor(urlExtension: getURLExtension ,completion: @escaping (MediaResult?, Error?) -> Void) {
        
        var url = baseURL
        url += urlExtension.rawValue
        
        let request = NSMutableURLRequest(url: NSURL(string: url) as? URL ?? URL(fileURLWithPath: ""),
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = self.headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let jsonData = data {
                    do {
                        let decoder = JSONDecoder()
                        switch urlExtension {
                        case .popularMovies, .trendingMovies:
                            let movieResponse = try decoder.decode(MovieResponse.self, from: jsonData)
                            completion(.movies(movieResponse.results), nil)
                        case .popularTVShows, .trendingTVShows:
                            let tvShowResponse = try decoder.decode(TVShowResponse.self, from: jsonData)
                            completion(.tvShows(tvShowResponse.results), nil)
                        }
                    } catch {
                        print(error)
                        completion(nil, error)
                    }
                }
            }
        }
        dataTask.resume()
    }
}
