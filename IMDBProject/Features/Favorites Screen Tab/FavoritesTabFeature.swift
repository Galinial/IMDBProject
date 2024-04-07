//
//  FavoritesTabFeature.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct FavoritesTabFeature {
    
    let networkManager = NetworkManager()
    
    @ObservableState
    struct State: Equatable {
        var mediaItems: IdentifiedArrayOf<MediaItem>
        var path = StackState<MediaItemDetailsFeature.State>()
    }
    
    enum Action: Equatable {
        case viewOnAppear
        case moviesResponse([MediaItem])
        case tvShowResponse([MediaItem])
        case path(StackAction<MediaItemDetailsFeature.State, MediaItemDetailsFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .viewOnAppear:
                
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .favoriteMovies)
                    await send(.moviesResponse(result ?? []))
                }
            case let .moviesResponse(movies):
                state.mediaItems += IdentifiedArrayOf<MediaItem>(uniqueElements: movies)
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .favoriteTVShows)
                    await send(.tvShowResponse(result ?? []))
                }
            case let .tvShowResponse(tvShows):
                state.mediaItems += IdentifiedArrayOf<MediaItem>(uniqueElements: tvShows)
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
    
