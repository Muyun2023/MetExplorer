//  Views/TagFilteredCollectionView.swift
//  MetExplorer

import SwiftUI
import SwiftData

/// Displays artworks filtered by a specific tag.
struct TagFilteredCollectionView: View {
    let tag: String
    
    @Query private var allItems: [FavoriteItem]
    @State private var refreshToggle = false

    var filteredItems: [FavoriteItem] {
        allItems.filter { $0.tagName == tag }
    }

    var body: some View {
        List {
            ForEach(filteredItems, id: \.objectIDString) { item in
                NavigationLink {
                    ArtworkDetailView(objectID: Int(item.objectIDString) ?? 0)
                } label: {
                    HStack(spacing: 12) {
                        AsyncImage(url: URL(string: item.thumbnailURL ?? "")) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                ZStack {
                                    Color.gray.opacity(0.2)
                                    Image(systemName: "photo")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        .clipped()

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.title)
                                .font(.headline)
                        }

                        Spacer()
                        Text(item.tagName)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("“\(tag)” Collection")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if filteredItems.isEmpty {
                ContentUnavailableView(
                    "No Artworks",
                    systemImage: "heart.slash",
                    description: Text("No artworks found for this tag.")
                )
            }
        }
    }
}
