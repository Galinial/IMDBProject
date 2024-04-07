//
//  AppFeature.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import Foundation
import ComposableArchitecture

@Reducer
struct AppFeature {
    
    @ObservableState
    struct State: Equatable {
        var tab1 = HomeScreenFeature.State(mediaItems: [])
        var tab2 = MoviesTabFeature.State(mediaItems: [])
        var tab3 = TVShowsTabFeature.State(mediaItems: [])
        var tab4 = FavoritesTabFeature.State(mediaItems: [])
    }
    
    enum Action {
        case tab1(HomeScreenFeature.Action)
        case tab2(MoviesTabFeature.Action)
        case tab3(TVShowsTabFeature.Action)
        case tab4(FavoritesTabFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.tab1, action: \.tab1) {
           HomeScreenFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            MoviesTabFeature()
        }
        Scope(state: \.tab3, action: \.tab3) {
            TVShowsTabFeature()
        }
        Scope(state: \.tab4, action: \.tab4) {
            FavoritesTabFeature()
        }
        
        Reduce { state, action in
            return .none
        }
    }
}

