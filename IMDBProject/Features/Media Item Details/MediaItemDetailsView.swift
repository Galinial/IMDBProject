//
//  MediaItemDetailsView.swift
//  IMDBProject
//
//  Created by gal linial on 05/04/2024.
//

import SwiftUI
import ComposableArchitecture

struct MediaItemDetailsView: View {
    
    private let imageDownloadBaseURL = "https://image.tmdb.org/t/p/original"
    
    @Bindable var store: StoreOf<MediaItemDetailsFeature>
    
    var body: some View {
        Form {
            List {
                Section("Details") {
                    AsyncImage(url: URL(string: imageDownloadBaseURL + (store.mediaItem.posterPath ?? ""))) { phase in
                        if let image = phase.image {
                            // Display the loaded image
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 325, height: 600)
                        } else if phase.error != nil {
                            Color.gray
                        } else {
                            // Display loading view while loading
                            ProgressView()
                                .frame(width: 300, height: 600)
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    Button {
                        store.send(.favoriteButtonTapped(store.mediaItem))
                    } label: {
                        Image(systemName: store.state.isFavorite ? "star.fill" : "star")
                    }
                    Text("Title: \(store.mediaItem.originalName)")
                    Text("Rating: \(String(format: "%.1f", store.mediaItem.voteAverage))")
                    Text("Overview: \(store.mediaItem.overview)")
//                  Text("Trailer") couldn't find it in any GET API Request
//                  Text("case") couldn't find it in any GET API Request
                }
                    ForEach(store.state.reviews) { review in
                        Section("Review") {
                        List {
                            Text("Username: \(review.authorDetails.username)")
                            Text("Name: \(review.authorDetails.name)")
                            Text("Rating: \(review.authorDetails.rating)")
                            Text("Message: \(review.content)")
                        }
                    }
                }
            }
            .onAppear() {
                store.send(.viewOnAppear(store.mediaItem))
            }
        }
        .navigationTitle(Text(store.mediaItem.originalName))
    }
}
