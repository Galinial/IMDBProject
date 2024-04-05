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
    }
    
    enum Action: Equatable {
        case viewOnAppear
        case reviewResponse([Review])
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
                
            case .viewOnAppear:
                return .run { send in
                    let result = try? await networkManager.fetchReviews()
                    await send(.reviewResponse(result ?? []))
                }
            case let .reviewResponse(reviews):
                state.reviews = IdentifiedArrayOf<Review>(uniqueElements: reviews)
                return .none
            }
            
        }
        
    }
}

