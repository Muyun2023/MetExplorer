import SwiftUI
import SwiftData

struct CollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var refreshToggle = false
    @State private var viewModel = CollectionViewModel()
    @Bindable private var bindableViewModel: CollectionViewModel
    @Query private var allItems: [FavoriteItem]

    var items: [FavoriteItem] {
        let _ = refreshToggle // 强制刷新绑定
        return allItems
    }

    init() {
        let vm = CollectionViewModel()
        self._viewModel = State(wrappedValue: vm)
        self._bindableViewModel = Bindable(wrappedValue: vm)
    }

    var body: some View {
        NavigationStack {
            List {
                // ✅ 标签过滤区
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

                // ✅ 收藏作品展示区
                ForEach(viewModel.favoriteArtworks) { artwork in
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
        // ✅ 自动追踪收藏变化（避免重复加载 or 不刷新的问题）
        .task(id: items.count) {
            await viewModel.refreshFavorites(context: modelContext)

            // Optional: 输出调试日志
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

