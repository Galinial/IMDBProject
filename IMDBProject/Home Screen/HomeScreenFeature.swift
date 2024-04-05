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
        var mediaItems: IdentifiedArrayOf<MediaItem>
    }
    
    enum Action: Equatable {
        case viewOnAppear
        case trendingMoviesReponse([MediaItem])
        case popularMoviesResponse([MediaItem])
        case trendingTVShowsResponse([MediaItem])
        case popularTVShowsResponse([MediaItem])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .viewOnAppear:
                
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .trendingMovies)
                    await send(.trendingMoviesReponse(result ?? []))
                }
                    
            case let .trendingMoviesReponse(movies):
                state.mediaItems = IdentifiedArrayOf<MediaItem>(uniqueElements: movies)
                return .none
            case .popularMoviesResponse(_):
                return .none
            case .trendingTVShowsResponse(_):
                return .none
            case .popularTVShowsResponse(_):
                return .none
                
            }
        }
    }
}
