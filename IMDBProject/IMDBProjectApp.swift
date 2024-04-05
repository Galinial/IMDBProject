//
//  IMDBProjectApp.swift
//  IMDBProject
//
//  Created by gal linial on 04/04/2024.
//

import SwiftUI
import ComposableArchitecture

@main
struct IMDBProjectApp: App {
    var body: some Scene {
        WindowGroup {
            HomeScreenView(
                store: Store(initialState: HomeScreenFeature.State(
                    mediaItems: [])
                ) {
                    HomeScreenFeature()
                }
            )
        }
    }
}
