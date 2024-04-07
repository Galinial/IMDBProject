//
//  MediaItemDetailsFeature.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct MediaItemDetailsFeature {
    
    let networkManager = NetworkManager()
    
    @ObservableState
    struct State: Equatable {
        let mediaItem: MediaItem
        var reviews: IdentifiedArrayOf<Review>
        var isFavorite: Bool = false
    }
    
    enum Action: Equatable {
        case viewOnAppear(MediaItem)
        case isFavoriteResponse([MediaItem])
        case reviewResponse([Review])
        case favoriteButtonTapped(MediaItem)
        case favoriteStateUpdated(HTTPURLResponse)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case let .viewOnAppear(mediaItem):
                return .run { send in
                    let result = try? await networkManager.getMediaFor(endPoint: mediaItem.mediaResult == .movie ? .favoriteMovies : .favoriteTVShows)
                    await send(.isFavoriteResponse(result ?? []))

                }
                
            case let .isFavoriteResponse(mediaItems):
                let mediaItem = state.mediaItem
                state.isFavorite = mediaItems.map({ $0.id }).contains(mediaItem.id)
                return .run { send in
                    let result = try? await networkManager.fetchReviews(mediaType: mediaItem.mediaResult , mediaId: mediaItem.id.description)
                    await send(.reviewResponse(result ?? []))
                }
                
                
            case let .reviewResponse(reviews):
                state.reviews = IdentifiedArrayOf<Review>(uniqueElements: reviews)
                return .none
                
                
            case let .favoriteButtonTapped(mediaItem):
                
                if state.isFavorite == true {
                    return .none
                }
                
                state.isFavorite = true
                let isFavorite = state.isFavorite
                if state.isFavorite {
                    return .run { send in
                        let result = try? await networkManager.addFavoriteItem(mediaItem: mediaItem, isFavorite: isFavorite)
                        await send(.favoriteStateUpdated(result ?? HTTPURLResponse()))
                    }
                } else {
                    return .none
                }
                
            case .favoriteStateUpdated(_):
                // here we could manage if we made the POST Request succesfully, and make another task if we want.
                return .none
            }
        }
    }
}

