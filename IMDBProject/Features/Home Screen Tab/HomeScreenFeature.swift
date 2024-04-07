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
        
        var isHapticsEnabled = true
        var searchTerm = ""
        
        var filteredMedia: IdentifiedArrayOf<MediaItem> {
            guard !searchTerm.isEmpty else { return mediaItems }
            return mediaItems.filter({ $0.originalName.localizedCaseInsensitiveContains(searchTerm) })
        }
    }
    
    enum Action: BindableAction ,Equatable {
        case viewOnAppear
        case trendingMoviesReponse([MediaItem])
        case popularMoviesResponse([MediaItem])
        case trendingTVShowsResponse([MediaItem])
        case popularTVShowsResponse([MediaItem])
        case path(StackAction<MediaItemDetailsFeature.State, MediaItemDetailsFeature.Action>)
        
        case searchTermChanged(String)
        case binding(BindingAction<State>)
        
    }
    
    var body: some ReducerOf<Self> {
        
        BindingReducer()
        
        
        Reduce { state, action in
            switch action {
                
            case .viewOnAppear:
                
                return .run { send in
                    let result = try? await networkManager.getMediaFor(urlExtension: .trendingMovies)
                    await send(.trendingMoviesReponse(result ?? []))
                }
                
            case let .trendingMoviesReponse(movies):
                state.mediaItems += IdentifiedArrayOf<MediaItem>(uniqueElements: movies)
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
            case .binding(_):
                return .none
                	
            case .searchTermChanged:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            MediaItemDetailsFeature()
        }
    }
}


