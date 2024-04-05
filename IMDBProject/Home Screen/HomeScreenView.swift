//
//  HomeScreenView.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import SwiftUI
import ComposableArchitecture

struct HomeScreenView: View {
    
    private let imageDownloadBaseURL = "https://image.tmdb.org/t/p/original"
    
    let store: StoreOf<HomeScreenFeature>
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(store.state.mediaItems) { mediaItem in
                    VStack {
                        AsyncImage(url: URL(string: imageDownloadBaseURL + (mediaItem.backdropPath ?? ""))) { phase in
                            if let image = phase.image {
                                // Display the loaded image
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 600)
                            } else if phase.error != nil {
                                Color.gray
                            } else {
                                // Display loading view while loading
                                ProgressView()
                                    .frame(width: 250, height: 600)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.bottom, 8)
                        
                        Text(mediaItem.originalName)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 8)
                }
            }
        }.onAppear() {
            store.send(.viewOnAppear)
        }
    }
}
