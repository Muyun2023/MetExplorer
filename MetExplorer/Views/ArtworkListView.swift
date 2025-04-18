// Views/ArtworkListView.swift
// MetExplorer

import SwiftUI

struct ArtworkListView: View {
    @State private var viewModel = ArtworkListViewModel()
    let departmentId: Int
    let departmentName: String

    enum FilterOption: String, CaseIterable {
        case none = "All"
        case culture = "By Culture"
        case medium = "By Medium"
    }
    @State private var selectedFilter: FilterOption = .none
    @State private var showErrorAlert = false
    @State private var searchText = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Department title
            Text(departmentName)
                .font(.title3.bold())
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.top, 8)

            // Search bar (TextField used due to known simulator bug with `.searchable`)
            TextField("Search manually", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                .padding(.top, 6)
                .padding(.bottom,6)

            // Filter Picker
            Picker("Filter By", selection: $selectedFilter) {
                ForEach(FilterOption.allCases, id: \.self) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 16)
            .padding(.top, 6)
            .padding(.bottom,6)

            // Artwork List
            List {
                ForEach(currentFilteredArtworks) { artwork in
                    NavigationLink(destination: ArtworkDetailView(objectID: artwork.objectID)) {
                        HStack(alignment: .top, spacing: 12) {
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

                            VStack(alignment: .leading, spacing: 6) {
                                HTMLText(html: artwork.title)
                                    .font(.title3.bold())
                                    .foregroundColor(.primary)
                                    .lineLimit(2)

                                if !artwork.artistDisplayName.isEmpty {
                                    Text(artwork.artistDisplayName)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }

                                if selectedFilter != .none {
                                    Text(groupingText(for: artwork))
                                        .font(.caption)
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.vertical, 6)
                    }

                }
            }
            
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
                        "No Artworks With This Information",
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
    }

    // Filter artworks based on search text and selected filter
    private var currentFilteredArtworks: [Artwork] {
        let baseList = searchText.isEmpty
            ? viewModel.artworks
            : viewModel.artworks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }

        switch selectedFilter {
        case .none:
            return baseList
        case .culture:
            let filtered = baseList.filter {
                !$0.culture.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            }
            return filtered.sorted { $0.culture < $1.culture }
        case .medium:
            return baseList.filter { !$0.medium.isEmpty }
                .sorted { $0.medium < $1.medium }
        }
    }

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
