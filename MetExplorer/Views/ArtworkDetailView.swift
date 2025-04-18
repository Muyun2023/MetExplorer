//  Views/ArtworkDetailView.swift
//  MetExplorer

import SwiftUI
import SwiftData

struct ArtworkDetailView: View {
    @Environment(\.modelContext) private var modelContext
    let objectID: Int
    @State private var viewModel = ArtworkDetailViewModel()
    @State private var showTagSelector = false
    @State private var showCustomTagInput = false
    @State private var customTagName = ""
    @State private var isImageFullScreen = false
    @State private var refreshToggle = false

    var body: some View {
        ZStack {
            if let artwork = viewModel.artwork {
                detailContentView(artwork: artwork)
            } else if viewModel.isLoading {
                ProgressView("Loading artwork...")
            } else {
                ContentUnavailableView(
                    "Failed to Load",
                    systemImage: "exclamationmark.triangle",
                    description: Text(viewModel.errorMessage ?? "Please try again later")
                )
            }
        }
        .navigationTitle(viewModel.artwork?.title ?? "Artwork Detail")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
        .task {
            await viewModel.loadUserTags(from: modelContext)
            await viewModel.fetchArtworkDetail(objectID: objectID, context: modelContext)
        }
        .sheet(isPresented: $showTagSelector) {
            tagSelectionSheet()
        }
        .alert("Create New Tag", isPresented: $showCustomTagInput) {
            TextField("Tag name", text: $customTagName)
            Button("Add", action: confirmCustomTag)
            Button("Cancel", role: .cancel) { customTagName = "" }
        }
    }

    private func detailContentView(artwork: Artwork) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Display artwork image with tap-to-zoom
                AsyncImage(url: URL(string: artwork.primaryImage)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .onTapGesture { isImageFullScreen = true }
                    } else if phase.error != nil {
                        Color.gray.frame(height: 300).overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                        }
                    } else {
                        ProgressView().frame(height: 300)
                    }
                }

                // Display artwork details
                VStack(alignment: .leading, spacing: 8) {
                    Text(artwork.title)
                        .font(.title3.bold())

                    if !artwork.artistDisplayName.isEmpty {
                        Text(artwork.artistDisplayName)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }

                    Divider()
                    infoRow(label: "Date", value: artwork.objectDate)
                    infoRow(label: "Medium", value: artwork.medium)
                    infoRow(label: "Culture", value: artwork.culture)

                    if !artwork.descriptionText.isEmpty {
                        Divider()
                        Text("About This Artwork")
                            .font(.headline)
                        Text(artwork.descriptionText)
                            .font(.subheadline)
                    }
                }

                // Tag/collection button
                Button(action: { showTagSelector = true }) {
                    let idString = String(objectID)
                    let savedTagName = (try? modelContext.fetch(
                        FetchDescriptor<FavoriteItem>(
                            predicate: #Predicate { $0.objectIDString == idString }
                        )
                    ).first?.tagName)

                    HStack {
                        if let tag = savedTagName {
                            Text("Tagged as \(tag)")
                            Spacer()
                            Image(systemName: "checkmark.circle.fill")
                        } else {
                            Text("Add to Collection")
                            Spacer()
                            Image(systemName: "plus.circle")
                        }
                    }
                    .padding()
                    .background(savedTagName != nil ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
                    .cornerRadius(10)
                }
            }
            .padding()
        }
        .fullScreenCover(isPresented: $isImageFullScreen) {
            ZStack(alignment: .topTrailing) {
                ZoomableImage(imageURL: URL(string: artwork.primaryImage)!)
                Button(action: { isImageFullScreen = false }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                        .padding(20)
                        .background(Circle().fill(Color.black.opacity(0.5)))
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
        }
    }

    private func infoRow(label: String, value: String) -> some View {
        guard !value.isEmpty else { return AnyView(EmptyView()) }

        return AnyView(
            HStack(alignment: .top) {
                Text("\(label):")
                    .bold()
                    .frame(width: 80, alignment: .leading)
                Text(value)
                Spacer()
            }
            .font(.subheadline)
            .padding(.vertical, 2)
        )
    }

    private func tagSelectionSheet() -> some View {
        NavigationStack {
            List {
                Section("My Tags") {
                    ForEach(viewModel.recentTags, id: \.name) { tag in
                        HStack {
                            // Tag selection button
                            Button {
                                Task {
                                    await viewModel.toggleFavorite(with: tag, context: modelContext)
                                }

                                let idString = String(objectID)
                                if let existing = try? modelContext.fetch(
                                    FetchDescriptor<FavoriteItem>(
                                        predicate: #Predicate { $0.objectIDString == idString }
                                    )
                                ).first {
                                    existing.tagName = tag.name
                                } else {
                                    let newItem = FavoriteItem(objectID: objectID, tagName: tag.name)
                                    modelContext.insert(newItem)
                                }

                                try? modelContext.save()
                                refreshToggle.toggle()
                                showTagSelector = false
                            } label: {
                                HStack {
                                    Text(tag.emoji)
                                    Text(tag.name)
                                    Spacer()
                                    let _ = refreshToggle
                                    let idString = String(objectID)
                                    let savedTagName = (try? modelContext.fetch(
                                        FetchDescriptor<FavoriteItem>(
                                            predicate: #Predicate { $0.objectIDString == idString }
                                        )
                                    ).first?.tagName)

                                    if savedTagName == tag.name {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }

                            // Tag deletion button
                            Button {
                                let idString = String(objectID)
                                if let current = try? modelContext.fetch(
                                    FetchDescriptor<FavoriteItem>(
                                        predicate: #Predicate { $0.objectIDString == idString }
                                    )
                                ).first, current.tagName == tag.name {
                                    modelContext.delete(current)
                                    try? modelContext.save()
                                    refreshToggle.toggle()
                                }
                                viewModel.deleteTag(tag)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }

                // Custom tag creation
                Section {
                    Button {
                        showCustomTagInput = true
                        showTagSelector = false
                    } label: {
                        Label("Custom Tag", systemImage: "plus")
                    }
                }

                // Remove from collection
                if viewModel.isCollected {
                    Section {
                        Button(role: .destructive) {
                            Task {
                                await viewModel.removeFavorite(context: modelContext)
                            }

                            let idString = String(objectID)
                            if let existing = try? modelContext.fetch(
                                FetchDescriptor<FavoriteItem>(
                                    predicate: #Predicate { $0.objectIDString == idString }
                                )
                            ).first {
                                modelContext.delete(existing)
                                try? modelContext.save()
                                refreshToggle.toggle()
                            }

                            showTagSelector = false
                        } label: {
                            Label("Remove from Collection", systemImage: "trash")
                        }
                    }
                }
            }
            .navigationTitle("Tag This Artwork")
            .navigationBarTitleDisplayMode(.inline)
        }
        .presentationDetents([.medium])
    }

    private func confirmCustomTag() {
        guard !customTagName.isEmpty else { return }

        let newTag = FavoriteTag(emoji: "🔖", name: customTagName)
        let tagModel = UserTag(name: newTag.name, emoji: newTag.emoji)
        modelContext.insert(tagModel)

        Task {
            await viewModel.toggleFavorite(with: newTag, context: modelContext)
        }

        let idString = String(objectID)
        if let existing = try? modelContext.fetch(
            FetchDescriptor<FavoriteItem>(
                predicate: #Predicate { $0.objectIDString == idString }
            )
        ).first {
            existing.tagName = newTag.name
        } else {
            let item = FavoriteItem(objectID: objectID, tagName: newTag.name)
            modelContext.insert(item)
        }

        try? modelContext.save()
        customTagName = ""
        refreshToggle.toggle()
    }
}
