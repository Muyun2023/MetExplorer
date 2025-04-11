//  ArtworkDetailView.swift
//  MetExplorer

import SwiftUI

struct ArtworkDetailView: View {
    let objectID: Int
    @State private var viewModel = ArtworkDetailViewModel()
    
    @State private var isCollected=false
    @State private var selectedTag:String?=nil
    @State private var showTagSelector=false
    
    let availableTags=["❤️", "🔥", "🌟", "🧠", "🎨"]
    
    
    var body: some View {
        ScrollView {
            if let artwork = viewModel.artwork {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Main Image
                    AsyncImage(url: URL(string: artwork.primaryImage)) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(12)
                        } else {
                            Color.gray.frame(height: 300).cornerRadius(12)
                        }
                    }
                    
                    // Title and artist
                    Text(artwork.title)
                        .font(.title2)
                        .bold()
                    
                    if !artwork.artistDisplayName.isEmpty {
                        Text(artwork.artistDisplayName)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Basic Information
                    if !artwork.objectDate.isEmpty {
                        Text("Date: \(artwork.objectDate)")
                            .font(.subheadline)
                    }
                    
                    if !artwork.medium.isEmpty {
                        Text("Medium: \(artwork.medium)")
                            .font(.subheadline)
                    }
                    
                    Divider()
                    
                    Text("About")
                        .font(.headline)
                    
                    Text(artwork.descriptionText)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    Button(action: {
                        showTagSelector = true
                    }) {
                        Text(isCollected ? (selectedTag ?? "💾") : "Add to Collection")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(12)
                    }

                    
                    /**VStack(alignment: .leading, spacing: 8) {
                     Text("About this artwork")
                     .font(.headline)
                     
                     if !artwork.culture.isEmpty {
                     Text("Culture: \(artwork.culture)")
                     }
                     
                     if !artwork.country.isEmpty {
                     Text("Country: \(artwork.country)")
                     }
                     
                     if !artwork.creditLine.isEmpty {
                     Text("Credit Line: \(artwork.creditLine)")
                     }
                     
                     if !artwork.accessionYear.isEmpty {
                     Text("Acquired in \(artwork.accessionYear)")
                     }
                     }
                     .font(.subheadline)
                     .foregroundColor(.accentColor) */
                }
                .padding()
            } else if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else {
                Text("Artwork not found.")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Artwork Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                await viewModel.fetchArtworkDetail(objectID: objectID)
            }
        }
        .confirmationDialog("Choose a tag", isPresented: $showTagSelector) {
            ForEach(availableTags, id: \.self) { tag in
                Button(tag) {
                    selectedTag = tag
                    isCollected = true
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

