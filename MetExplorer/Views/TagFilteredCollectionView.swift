//  Views/TagFilteredCollectionView.swift
//  MetExplorer

import SwiftUI
import SwiftData

/// Displays artworks filtered by a specific tag.
struct TagFilteredCollectionView: View {
    let tag: String
    
    @Query private var items: [FavoriteItem]
    @State private var artworks: [Artwork] = []
    @State private var isLoading = false
    @State private var didLoad = false  // Prevent multiple loads

    var body: some View {
        List {
            ForEach(artworks) { artwork in
                NavigationLink {
                    ArtworkDetailView(objectID: artwork.objectID)
                } label: {
                    HStack {
                        AsyncImage(url: URL(string: artwork.primaryImageSmall)) { phase in
                            if let image = phase.image {
                                image.resizable().scaledToFill()
                            } else {
                                Color.gray.opacity(0.3)
                            }
                        }
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)

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
                        Text(tag)
                    }
                }
            }
        }
        .navigationTitle(tag)
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if isLoading {
                ProgressView("Loading...")
            } else if artworks.isEmpty {
                ContentUnavailableView(
                    "No Artworks",
                    systemImage: "star.slash",
                    description: Text("No artworks found with this tag.")
                )
            }
        }
        .onAppear {
            if !didLoad {
                didLoad = true
                Task {
                    await loadArtworks()
                }
            }
        }
    }

    /// Loads artworks from the Met API based on filtered FavoriteItems with the given tag.
    private func loadArtworks() async {
        isLoading = true
        
        // Filter saved favorites by tag
        let matchingItems = items.filter { $0.tagName == tag }
        
        var results: [Artwork] = []
        for item in matchingItems {
            if let id = Int(item.objectIDString) {
                do {
                    let artwork = try await MetMuseumAPI.shared.fetchArtwork(by: id)
                    results.append(artwork)
                } catch {
                    print("Error loading artwork \(id): \(error)")
                }
            }
        }
        
        artworks = results
        isLoading = false
    }
}

