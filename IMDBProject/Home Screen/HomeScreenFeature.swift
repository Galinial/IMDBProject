//
//  HomeScreenFeature.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation
import ComposableArchitecture
import SwiftUI

@Reducer
struct HomeScreenFeature {
    
    let networkManager = NetworkManager()
    
    @ObservableState
    struct State: Equatable {
        var mediaResult: IdentifiedArrayOf<MediaResult>
    }
    
    enum Action: Equatable {
        case viewOnAppear
        case trendingMoviesReponse([Movie])
        case popularMoviesResponse([Movie])
        case trendingTVShowsResponse([TVShow])
        case popularTVShowsResponse([TVShow])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .viewOnAppear:
                return .run { send in
                    networkManager.getMediaFor(urlExtension: .trendingMovies) { mediaResult, error in
                        if let mediaResult = mediaResult {
                            switch mediaResult {
                            case .movies(let movies):
                                DispatchQueue.main.async {
                                    send(.trendingMoviesReponse(movies))
                                }
                            default:
                                break
                            }
                        } else if let error = error {
                            // Handle error
                        }
                    }
                }
            case let .trendingMoviesReponse(movies):
                state.mediaResult = IdentifiedArrayOf(uniqueElements: movies.map { MediaResult.movies([$0]) })
                return .none
            case .popularMoviesResponse(_):
                return .run { send in
                    networkManager.getMediaFor(urlExtension: .trendingMovies) { mediaResult, error in
                        if let mediaResult = mediaResult {
                            switch mediaResult {
                            case .movies(let movies):
                                DispatchQueue.main.async {
                                    send(.trendingMoviesReponse(movies))
                                }
                            default:
                                break
                            }
                        } else if let error = error {
                            // Handle error
                        }
                    }
                }
            case .trendingTVShowsResponse(_):
                return .run { send in
                    networkManager.getMediaFor(urlExtension: .trendingMovies) { mediaResult, error in
                        if let mediaResult = mediaResult {
                            switch mediaResult {
                            case .movies(let movies):
                                DispatchQueue.main.async {
                                    send(.trendingMoviesReponse(movies))
                                }
                            default:
                                break
                            }
                        } else if let error = error {
                            // Handle error
                        }
                    }
                }
            case .popularTVShowsResponse(_):
                return .run { send in
                    networkManager.getMediaFor(urlExtension: .trendingMovies) { mediaResult, error in
                        if let mediaResult = mediaResult {
                            switch mediaResult {
                            case .movies(let movies):
                                DispatchQueue.main.async {
                                    send(.trendingMoviesReponse(movies))
                                }
                            default:
                                break
                            }
                        } else if let error = error {
                            // Handle error
                        }
                    }
                }
                
            }
        }
    }
}
