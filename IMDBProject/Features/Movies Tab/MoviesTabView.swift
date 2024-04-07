//
//  MoviesTabView.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import SwiftUI
import ComposableArchitecture

struct MoviesTabView: View {
    
    private let imageDownloadBaseURL = "https://image.tmdb.org/t/p/original"
    
    let columns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    
    @Bindable var store: StoreOf<MoviesTabFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 0) {
                    ForEach(store.mediaItems) { mediaItem in
                        NavigationLink(state: MediaItemDetailsFeature.State(mediaItem: mediaItem, reviews: [])) {
                            AsyncImage(url: URL(string: imageDownloadBaseURL + (mediaItem.posterPath ?? ""))) { phase in
                                switch phase {
                                case .empty:
                                    ProgressView()
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: (UIScreen.main.bounds.width - 15) / 3, maxHeight: .infinity)
                                case .failure:
                                    ProgressView()
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(height: 200)
                        }
                    }
                }
            }
        } destination: { store in
            MediaItemDetailsView(store: store)
        }
        .onAppear {
            store.send(.viewOnAppear)
        }
    }
}
