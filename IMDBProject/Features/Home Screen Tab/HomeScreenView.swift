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
    
    @Bindable var store: StoreOf<HomeScreenFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: \.path)) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(store.state.filteredMedia) { mediaItem in
                        NavigationLink(state: MediaItemDetailsFeature.State(mediaItem: mediaItem, reviews: [])) {
                            VStack {
                                AsyncImage(url: URL(string: imageDownloadBaseURL + (mediaItem.posterPath ?? ""))) { phase in
                                    if let image = phase.image {
                                        // Display the loaded image
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
                }
                .padding(.horizontal, 8)
            }
            .searchable(text: $store.searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        }destination: { store in
            MediaItemDetailsView(store: store)
        }
        
        .onAppear() {
            store.send(.viewOnAppear)
        }
    }
}
