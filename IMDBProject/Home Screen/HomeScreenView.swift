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
        List {
            ForEach(store.mediaResult) { media in
                switch media {
                case .movies(let movies):
                    VStack {
                        ForEach(movies) { movie in
                            HStack {
                                Text(movie.title)
                                AsyncImage(url: URL(string: imageDownloadBaseURL + (movie.backdropPath ?? ""))) { phase in
                                    if let image = phase.image {
                                        // Display the loaded image
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 200, height: 200)
                                            .clipShape(.circle)
                                    } else if phase.error != nil {
                                        Color.gray
                                            .frame(width: 200, height: 200)
                                    } else {
                                        // Display loading view while loading
                                        ProgressView()
                                            .frame(width: 200, height: 200)
                                    }
                                    
                                }
                            }
                        }
                    }
                case .tvShows(let tvShows):
                    VStack {
                        ForEach(tvShows) { tvShow in
                            Text(tvShow.name)
                        }
                    }
                }
            }
        }.onAppear() {
            store.send(.viewOnAppear)
        }
    }
}
