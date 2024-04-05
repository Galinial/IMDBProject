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
    
    let store: StoreOf<MediaItemDetailsFeature>
    
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
                    Text("Title: \(store.mediaItem.originalName)")
                    Text("Rating: \(store.mediaItem.voteAverage)")
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
            .onAppear {
                store.send(.viewOnAppear)
            }
        }
        .navigationTitle(Text(store.mediaItem.originalName))
    }
}

#Preview {
    MediaItemDetailsView(
        store: Store(
            initialState: MediaItemDetailsFeature.State(mediaItem: MediaItem(genreIds: [], id: 1, originalLanguage: "", overview: "", popularity: 0.0, voteAverage: 0.0, voteCount: 0, originalName: "Kung Fu Panda 4", mediaResult: .movie), reviews: [])) {
                MediaItemDetailsFeature()
            })
}
