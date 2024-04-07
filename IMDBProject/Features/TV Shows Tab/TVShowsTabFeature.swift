//
//  TVShowsTabFeature.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct TVShowsTabFeature {
    
    let networkManager = NetworkManager()
    
    @ObservableState
    struct State: Equatable {
        var mediaItems: IdentifiedArrayOf<MediaItem>
        var path = StackState<MediaItemDetailsFeature.State>()
    }
    
    enum Action: Equatable {
        case viewOnAppear
        case topRatedTVShowResponse([MediaItem])
        case trendingTVShows([MediaItem]) // used trending instead of now playing, there isn't a now playing TVShow api GET request
        case popularTVShowResponse([MediaItem])
        case path(StackAction<MediaItemDetailsFeature.State, MediaItemDetailsFeature.Action>)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .viewOnAppear:
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .topRatedTVshows)
                    await send(.topRatedTVShowResponse(result ?? []))
                }
            case let .topRatedTVShowResponse(tvShows):
                state.mediaItems += IdentifiedArrayOf<MediaItem>(uniqueElements: tvShows)
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .trendingTVShows)
                    await send(.trendingTVShows(result ?? []))
                }
            case let .trendingTVShows(tvShows):
                state.mediaItems += IdentifiedArrayOf<MediaItem>(uniqueElements: tvShows)
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .popularTVShows)
                    await send(.popularTVShowResponse(result ?? []))
                }
            case let .popularTVShowResponse(movies):
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
