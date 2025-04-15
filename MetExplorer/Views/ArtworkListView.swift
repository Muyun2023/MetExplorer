// Views/ArtworkListView.swift
//  MetExplorer

import SwiftUI

struct ArtworkListView: View {
    @State private var viewModel = ArtworkListViewModel()
    let departmentId: Int
    let departmentName:String
    
    // 新增过滤状态
    enum FilterOption: String, CaseIterable {
        case none = "All"
        case culture = "By Culture"
        case medium = "By Medium"
    }
    @State private var selectedFilter: FilterOption = .none
    @State private var showErrorAlert = false
    
    var body: some View {
        List {
            // 新增过滤控制栏
            Section {
                Picker("Filter By", selection: $selectedFilter) {
                    ForEach(FilterOption.allCases, id: \.self) { option in
                        Text(option.rawValue).tag(option)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.vertical, 8)
            }
            
            // 艺术品列表
            ForEach(currentFilteredArtworks) { artwork in
                NavigationLink(destination: ArtworkDetailView(objectID: artwork.objectID)) {
                    HStack(alignment: .top, spacing: 12) {
                        // 缩略图
                        AsyncImage(url: URL(string: artwork.primaryImageSmall)) { phase in
                            if let image = phase.image {
                                image.resizable()
                            } else if phase.error != nil {
                                Color.gray.opacity(0.3)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 60, height: 60)
                        .cornerRadius(8)
                        
                        // 文字信息
                        VStack(alignment: .leading, spacing: 4) {
                            //Text(artwork.title)
                            HTMLText(html: artwork.title) //feedback that avoid html tag
                                .font(.headline)
                                .lineLimit(2)
                            
                            if !artwork.artistDisplayName.isEmpty {
                                Text(artwork.artistDisplayName)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            // 显示分组字段（当过滤激活时）
                            if selectedFilter != .none {
                                Text(groupingText(for: artwork))
                                    .font(.caption)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
            }
        }
        .navigationTitle(departmentName) // Professor feedback that change name from artwork to dn
        .navigationBarTitleDisplayMode(.inline) //Show Dn full name
        .searchable(text: $viewModel.searchText, prompt: "Search artworks")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShuffledButton {
                    Task { await viewModel.fetchArtworks(departmentId: departmentId) }
                }
            }
        }
        .alert(
            "Load Failed",
            isPresented: $showErrorAlert,
            presenting: viewModel.errorMessage,
            actions: { _ in
                Button("Retry") {
                    Task { await viewModel.fetchArtworks(departmentId: departmentId) }
                }
                Button("Cancel", role: .cancel) {}
            },
            message: { Text($0) }
        )
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if currentFilteredArtworks.isEmpty && !viewModel.isLoading {
                ContentUnavailableView(
                    "No Artworks",
                    systemImage: "photo.on.rectangle.angled",
                    description: Text(viewModel.errorMessage ?? "Try another search term")
                )
            }
        }
        .task {
            if viewModel.artworks.isEmpty {
                await viewModel.fetchArtworks(departmentId: departmentId)
            }
        }
        .onChange(of: viewModel.errorMessage) { _, newValue in
            showErrorAlert = (newValue != nil)
        }
    }
    
    // 当前显示的 artworks（结合搜索和过滤）
    private var currentFilteredArtworks: [Artwork] {
        let baseList = viewModel.filteredArtworks  // 已处理搜索
        
        switch selectedFilter {
        case .none:
            return baseList
        case .culture:
            return baseList
                .filter { !$0.culture.isEmpty }
                .sorted { $0.culture < $1.culture }
        case .medium:
            return baseList
                .filter { !$0.medium.isEmpty }
                .sorted { $0.medium < $1.medium }
        }
    }
    
    // 分组字段显示文本
    private func groupingText(for artwork: Artwork) -> String {
        switch selectedFilter {
        case .culture:
            return artwork.culture.isEmpty ? "Unknown Culture" : artwork.culture
        case .medium:
            return artwork.medium.isEmpty ? "Unknown Medium" : artwork.medium
        case .none:
            return ""
        }
    }
}

//// 预览（模拟数据）
//#Preview {
//    NavigationStack {
//        ArtworkListView(departmentId: 1)
//    }
//}
