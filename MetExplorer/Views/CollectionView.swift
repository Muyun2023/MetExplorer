// Views/CollectionView.swift
// MetExplorer

import SwiftUI
import SwiftData

struct CollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var refreshToggle = false
    @State private var viewModel = CollectionViewModel()
    @Bindable private var bindableViewModel: CollectionViewModel
    @Query private var allItems: [FavoriteItem]
    @State private var searchText = ""

    // Derived property to trigger view update
    var items: [FavoriteItem] {
        let _ = refreshToggle
        return allItems
    }

    init() {
        let vm = CollectionViewModel()
        self._viewModel = State(wrappedValue: vm)
        self._bindableViewModel = Bindable(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search bar for local favorites
                TextField("Search My Collection", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                    .padding(.top, 8)

                List {
                    // Tag filter section
                    let uniqueTags = Set(items.map { $0.tagName })
                    if !uniqueTags.isEmpty {
                        Section("Tags") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(Array(uniqueTags), id: \.self) { tag in
                                        NavigationLink(destination: TagFilteredCollectionView(tag: tag)) {
                                            Text(tag)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.blue.opacity(0.2))
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    // Favorite artworks section with search filtering
                    ForEach(viewModel.favoriteArtworks.filter {
                        searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)
                    }) { artwork in
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
                            }
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
                    await viewModel.refreshFavorites(context: modelContext)
                }
            }
        }
        // Automatically update when item count changes (SwiftData updates)
        .task(id: items.count) {
            await viewModel.refreshFavorites(context: modelContext)

            // Debug log of current SwiftData state
            do {
                let allFavorites = try modelContext.fetch(FetchDescriptor<FavoriteItem>())
                print("✅ Current SwiftData has \(allFavorites.count) items")
                for item in allFavorites {
                    print("🎯 objectID: \(item.objectIDString), tag: \(item.tagName)")
                }
            } catch {
                print("❌ Failed to fetch from SwiftData: \(error)")
            }
        }
    }
}
