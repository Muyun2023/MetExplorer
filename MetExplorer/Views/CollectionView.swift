import SwiftUI
import SwiftData

struct CollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var refreshToggle = false
    @State private var viewModel = CollectionViewModel()
    @Bindable private var bindableViewModel: CollectionViewModel
    @Query private var allItems: [FavoriteItem]
    @State private var searchText = ""

    var items: [FavoriteItem] {
        let _ = refreshToggle // trigger recompute
        return allItems
    }

    init() {
        let vm = CollectionViewModel()
        self._viewModel = State(wrappedValue: vm)
        self._bindableViewModel = Bindable(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Collection")
                        .font(.largeTitle.bold())
                        .padding(.horizontal)

                    TextField("Search favorites", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                .padding(.top, 8)

                List {
                    // Tags Section
                    let uniqueTags = Set(items.map { $0.tagName })
                    if !uniqueTags.isEmpty {
                        Section("Tags") {
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(Array(uniqueTags), id: \.self) { tag in
                                        NavigationLink(destination: TagFilteredCollectionView(tag: tag)) {
                                            Text(tag)
                                                .font(.subheadline)
                                                .padding(.horizontal, 12)
                                                .padding(.vertical, 6)
                                                .background(Color.blue.opacity(0.15))
                                                .cornerRadius(10)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }

                    // Favorites Section
                    Section("Saved Artworks") {
                        ForEach(viewModel.favoriteArtworks.filter {
                            searchText.isEmpty || $0.title.localizedCaseInsensitiveContains(searchText)
                        }) { artwork in
                            NavigationLink {
                                ArtworkDetailView(objectID: artwork.objectID)
                            } label: {
                                HStack(spacing: 12) {
                                    AsyncImage(url: URL(string: artwork.primaryImageSmall)) { phase in
                                        if let image = phase.image {
                                            image.resizable().scaledToFill()
                                        } else {
                                            Color.gray.opacity(0.3)
                                        }
                                    }
                                    .frame(width: 60, height: 60)
                                    .cornerRadius(8)
                                    .clipped()

                                    VStack(alignment: .leading, spacing: 4) {
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
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Color(.systemGroupedBackground))
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .refreshable {
                await viewModel.refreshFavorites(context: modelContext)
            }
            .overlay {
                if viewModel.favoriteArtworks.isEmpty {
                    ContentUnavailableView(
                        "No Favorites Yet",
                        systemImage: "heart.slash",
                        description: Text("Tap the heart in artwork details to save")
                    )
                }
            }
        }
        .task(id: items.count) {
            await viewModel.refreshFavorites(context: modelContext)

            do {
                let allFavorites = try modelContext.fetch(FetchDescriptor<FavoriteItem>())
                print("✅ Current SwiftData has \(allFavorites.count) 项")
                for item in allFavorites {
                    print("🎯 Save objectID: \(item.objectIDString), tag: \(item.tagName)")
                }
            } catch {
                print("❌ SwiftData Read/Get fail: \(error)")
            }
        }
    }
}
