//  CollectionView.swift
//  MetExplorer

import SwiftUI
import SwiftData


struct CollectionView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = CollectionViewModel()
    @Bindable private var bindableViewModel: CollectionViewModel

    init() {
        let vm = CollectionViewModel()
        self._viewModel = State(wrappedValue: vm)
        self._bindableViewModel = Bindable(wrappedValue: vm)
    }
    
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
                await viewModel.refreshFavorites(context: modelContext)
            }
//            .refreshable {
//                await viewModel.refreshFavorites()
//            }
            .task {
                    await viewModel.refreshFavorites(context: modelContext)
                }
            .task {
                do {
                    let allFavorites = try modelContext.fetch(FetchDescriptor<FavoriteItem>())
                    print("✅ 当前收藏 SwiftData 中有 \(allFavorites.count) 项")
                    for item in allFavorites {
                        print("🎯 收藏 objectID: \(item.objectIDString), tag: \(item.tagName)")
                    }
                } catch {
                    print("❌ SwiftData 读取失败: \(error)")
                }
            }

        }
    }
}

//// 预览（模拟数据）
//#Preview {
//    CollectionView()
//}

