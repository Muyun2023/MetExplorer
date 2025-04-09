//  ArtworkListView.swift
//  MetExplorer

import SwiftUI

struct ArtworkListView:View {
    let departmentId: Int
    @State private var viewModel = ArtworkListViewModel()

    var body: some View {
        List(viewModel.artworks) { artwork in
            NavigationLink(destination: ArtworkDetailView(objectID:artwork.objectID)){
                
                HStack(alignment: .top) {
                    AsyncImage(url: URL(string: artwork.primaryImageSmall)) { phase in
                        if let image = phase.image {
                            image.resizable()
                        } else {
                            Color.gray
                        }
                    }
                    .frame(width: 60, height: 60)
                    .cornerRadius(8)
                }
                
                VStack(alignment: .leading) {
                    Text(artwork.title)
                        .font(.headline)

                    if !artwork.artistDisplayName.isEmpty {
                        Text(artwork.artistDisplayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Artworks")
        .onAppear {
            Task {
                await viewModel.fetchArtworks(departmentId: departmentId)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShuffledButton{
                    Task {
                        await viewModel.fetchArtworks(departmentId: departmentId)
                    }
                }
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView("Loading...")
            }
        }
    }
}

