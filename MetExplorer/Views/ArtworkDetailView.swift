//  ArtworkDetailView.swift
//  MetExplorer

import SwiftUI

struct ArtworkDetailView: View {
    let objectID: Int
    @State private var showTagSelector = false
    @State private var showCustomTagInput = false
    @State private var customTagText = ""
    @State private var isImageFullScreen = false
    @State private var viewModel = ArtworkDetailViewModel()
    
    var body: some View {
        ZStack {
            ScrollView {
                if let artwork = viewModel.artwork {
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // AsyncImage
                        AsyncImage(url: URL(string: artwork.primaryImage)) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .cornerRadius(12)
                                    .onTapGesture {
                                        isImageFullScreen = true
                                    }
                            } else {
                                Color.gray
                                    .frame(height: 300)
                                    .cornerRadius(12)
                            }
                        }
                        
                        Text(artwork.title).font(.title2).bold()
                        
                        if !artwork.artistDisplayName.isEmpty {
                            Text(artwork.artistDisplayName)
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        
                        if !artwork.objectDate.isEmpty {
                            Text("Date: \(artwork.objectDate)").font(.subheadline)
                        }
                        
                        if !artwork.medium.isEmpty {
                            Text("Medium: \(artwork.medium)").font(.subheadline)
                        }
                        
                        Divider()
                        
                        Text("About").font(.headline)
                        Text(artwork.descriptionText)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        // Save button
                        Button {
                            showTagSelector = true
                        } label: {
                            Label(
                                viewModel.isCollected ? "\(viewModel.selectedTag?.emoji ?? "❤️")" : "Add to Collection",
                                systemImage: viewModel.isCollected ? "heart.fill" : "heart"
                            )
                            .padding()
                            .background(Color.accentColor.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                } else if viewModel.isLoading {
                    ProgressView("Loading...").padding()
                } else {
                    Text("Artwork not found.").foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Artwork Detail")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task { await viewModel.fetchArtworkDetail(objectID: objectID) }
        }
        
        // Tag Selector Sheet
        .sheet(isPresented: $showTagSelector) {
            NavigationView {
                List {
                    Section(header: Text("Recent Tags")) {
                        ForEach(viewModel.recentTags, id: \.self) { tag in
                            HStack {
                                Button {
                                    viewModel.toggleFavorite(with: tag)
                                    showTagSelector = false
                                } label: {
                                    Text("\(tag.emoji) \(tag.name)")
                                }

                                Spacer()

                                Button {
                                    viewModel.deleteCustomTag(tag)
                                } label: {
                                    Image(systemName: "trash")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                    
                    Section {
                        Button("Custom...") {
                            showCustomTagInput = true
                        }
                    }
                    
                    if viewModel.isCollected {
                        Section {
                            Button("Remove from Collection", role: .destructive) {
                                viewModel.removeFavorite()
                                showTagSelector = false
                            }
                        }
                    }
                }
                .navigationTitle("Select Tag")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Cancel") {
                            showTagSelector = false
                        }
                    }
                }
            }
        }
        
        // Custom tag alert
        .alert("New Tag", isPresented: $showCustomTagInput) {
            TextField("Tag name", text: $customTagText)
            Button("Add") {
                let newTag = FavoriteTag(emoji: "💡", name: customTagText)
                viewModel.toggleFavorite(with: newTag)
                customTagText = ""
                showTagSelector = false
            }
            Button("Cancel", role: .cancel) {}
        }
        
        // Full screen image view
        .fullScreenCover(isPresented: $isImageFullScreen) {
                    ZStack(alignment: .topTrailing) {
                        if let imageURL = URL(string: viewModel.artwork?.primaryImage ?? "") {
                            ZoomableImage(imageURL: imageURL)
                        }

                        Button {
                            isImageFullScreen = false
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                                .padding()
                        }
                    }
                }
            }
        }
