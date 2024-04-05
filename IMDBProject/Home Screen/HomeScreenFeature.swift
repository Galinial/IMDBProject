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
        var path = StackState<MediaItemDetailsFeature.State>()
    }
    
    enum Action: Equatable {
        case viewOnAppear
        case trendingMoviesReponse([MediaItem])
        case popularMoviesResponse([MediaItem])
        case trendingTVShowsResponse([MediaItem])
        case popularTVShowsResponse([MediaItem])
        case path(StackAction<MediaItemDetailsFeature.State, MediaItemDetailsFeature.Action>)
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
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .popularMovies)
                    await send(.popularMoviesResponse(result ?? []))
                }
            case let .popularMoviesResponse(movies):
                state.mediaItems += movies
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .trendingTVShows)
                    await send(.trendingTVShowsResponse(result ?? []))
                }
            case let .trendingTVShowsResponse(tvShows):
                state.mediaItems += tvShows
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .trendingTVShows)
                    await send(.trendingTVShowsResponse(result ?? []))
                }
            case let .popularTVShowsResponse(tvShows):
                state.mediaItems += tvShows
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .popularTVShows)
                    await send(.popularTVShowsResponse(result ?? []))
                }
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            MediaItemDetailsFeature()
        }
    }
}

