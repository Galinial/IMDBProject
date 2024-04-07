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
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 325, height: 600)
                        } else if phase.error != nil {
                            Color.gray
                        } else {
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
                    HStack(alignment: .firstTextBaseline) {
                        Text("Title: ").fontWeight(.bold)
                        Text(store.mediaItem.originalName)
                    }
                    HStack(alignment: .firstTextBaseline) {
                        Text("Rating: ").fontWeight(.bold)
                        Text(String(format: "%.1f", store.mediaItem.voteAverage))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Overview: ").fontWeight(.bold)
                        Text(store.mediaItem.overview)
                    }
//                  *Trailer* couldn't find it in any GET API Request
//                  *case* couldn't find it in any GET API Request
                }
                ForEach(store.state.reviews) { review in
                    Section("Review") {
                        List {
                            HStack(alignment: .firstTextBaseline) {
                                Text("Username: ").fontWeight(.bold)
                                Text(review.authorDetails.username)
                            }
                            if !review.authorDetails.name.isEmpty {
                                HStack(alignment: .firstTextBaseline) {
                                    Text("Name: ").fontWeight(.bold)
                                    Text(review.authorDetails.name)
                                }
                            }
                            HStack(alignment: .firstTextBaseline) {
                                Text("Rating: ").fontWeight(.bold)
                                Text(review.authorDetails.rating.description)
                            }
                            VStack(alignment: .leading) {
                                Text("Message: ").fontWeight(.bold)
                                Text(review.content)
                            }
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
