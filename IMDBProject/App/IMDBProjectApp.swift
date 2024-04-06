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
            AppView(store: Store(
                initialState: AppFeature.State()
                ) {
                    AppFeature()
                })
        }
    }
}
