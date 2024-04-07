//
//  MoviesTabFeature.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MoviesTabFeature {
    
    let networkManager = NetworkManager()
    
    @ObservableState
    struct State: Equatable {
        var mediaItems: IdentifiedArrayOf<MediaItem>
        var path = StackState<MediaItemDetailsFeature.State>()
    }
    
    enum Action: Equatable {
        case viewOnAppear
        case topRatedMoviesResponse([MediaItem])
        case nowPlayingMoviesResponse([MediaItem])
        case popularMoviesResponse([MediaItem])
        case path(StackAction<MediaItemDetailsFeature.State, MediaItemDetailsFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .viewOnAppear:
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .topRatedMovies)
                    await send(.topRatedMoviesResponse(result ?? []))
                }
            case let .topRatedMoviesResponse(movies):
                state.mediaItems += IdentifiedArrayOf<MediaItem>(uniqueElements: movies)
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .nowPlayingMovies)
                    await send(.nowPlayingMoviesResponse(result ?? []))
                }
            case let .nowPlayingMoviesResponse(movies):
                state.mediaItems += IdentifiedArrayOf<MediaItem>(uniqueElements: movies)
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .popularMovies)
                    await send(.popularMoviesResponse(result ?? []))
                }
            case let .popularMoviesResponse(movies):
                state.mediaItems += IdentifiedArrayOf<MediaItem>(uniqueElements: movies)
                return .none
            case .path:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            MediaItemDetailsFeature()
        }
    }
}
