//
//  AppView.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import SwiftUI
import ComposableArchitecture

struct AppView: View {
    
    @Bindable var store: StoreOf<AppFeature>
    
    var body: some View {
        
        TabView {
            HomeScreenView(store: store.scope(state: \.tab1, action: \.tab1))
                .tabItem {
                    Label(
                        title: { Text("Home") },
                        icon: { Image(systemName: "house")}
                    )
                }
            MoviesTabView(store: store.scope(state: \.tab2, action: \.tab2))
                .tabItem {
                    Label(
                        title: { Text("Movies") },
                        icon: { Image(systemName: "film")}
                    )
                }
        }
    }
}
