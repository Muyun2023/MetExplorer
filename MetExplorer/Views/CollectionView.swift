//  CollectionView.swift
//  MetExplorer

import SwiftUI

struct CollectionView: View {
    @State private var viewModel = CollectionViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.favoriteArtworks) { artwork in
                NavigationLink {
                    ArtworkDetailView(objectID: artwork.objectID)
                } label: {
                    HStack {
                        // image
                        AsyncImage(url: URL(string: artwork.primaryImageSmall)) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                        
                        // Text
                        VStack(alignment: .leading) {
                            Text(artwork.title)
                                .font(.headline)
                            if !artwork.artistDisplayName.isEmpty {
                                Text(artwork.artistDisplayName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        // emoji
                        Text(viewModel.tagEmoji(for: artwork.objectID))
                    }
                }
            }
            .navigationTitle("My Collection")
            .overlay {
                if viewModel.favoriteArtworks.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart.slash",
                        description: Text("Tap the heart in artwork details to save")
                    )
                }
            }
            .refreshable {
                await viewModel.refreshFavorites()
            }
        }
    }
}

//// 预览（模拟数据）
//#Preview {
//    CollectionView()
//}

