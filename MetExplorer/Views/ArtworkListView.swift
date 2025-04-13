//  ArtworkListView.swift
//  MetExplorer

import SwiftUI

struct ArtworkListView: View {
    @State private var viewModel = ArtworkListViewModel()
    let departmentId: Int
    
    @State private var showErrorAlert = false
    
    var body: some View {
        List(viewModel.filteredArtworks) { artwork in
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
                    
                    // Text info
                    VStack(alignment: .leading, spacing: 4) {
                        Text(artwork.title)
                            .font(.headline)
                            .lineLimit(1)
                        
                        if !artwork.artistDisplayName.isEmpty {
                            Text(artwork.artistDisplayName)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Artworks")
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
            } else if viewModel.filteredArtworks.isEmpty && !viewModel.isLoading {
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
}


//#Preview {
//    NavigationStack {
//        ArtworkListView(departmentId: 1)
//    }
//}

