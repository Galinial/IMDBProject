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
    }
    
    enum Action {
        case tab1(HomeScreenFeature.Action)
        case tab2(MoviesTabFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        
        Scope(state: \.tab1, action: \.tab1) {
           HomeScreenFeature()
        }
        Scope(state: \.tab2, action: \.tab2) {
            MoviesTabFeature()
        }
        
        Reduce { state, action in
            return .none
        }
    }
}

