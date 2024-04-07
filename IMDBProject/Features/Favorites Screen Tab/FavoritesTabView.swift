//
//  FavoritesTabView.swift
//  IMDBProject
//
//  Created by gal linial on 06/04/2024.
//

import SwiftUI
import ComposableArchitecture

struct FavoritesTabView: View {
        
    @Bindable var store: StoreOf<FavoritesTabFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            List(store.state.mediaItems) { mediaItem in
                NavigationLink(state: MediaItemDetailsFeature.State(mediaItem: mediaItem, reviews: [])) {
                    VStack {
                        AsyncImage(url: URL(string: store.state.imageDownloadBaseURL + (mediaItem.posterPath ?? ""))) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 250, height: 500)
                            } else {
                                ProgressView()
                                    .frame(width: 250, height: 500)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.bottom, 8)
                        
                        Text(mediaItem.originalName)
                            .lineLimit(1)
                            .font(.headline)
                            .truncationMode(.tail)
                            .foregroundStyle(.black)
                        
                    }
                    .frame(width: 250)
                    .padding(.horizontal, 8)
                }
            }
            
        } destination: { store in
            MediaItemDetailsView(store: store)
        }
        .onAppear() {
            store.send(.viewOnAppear)
        }
    }
}
