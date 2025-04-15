//  ArtworkDetailView.swift
//  MetExplorer

import SwiftUI
import SwiftData

struct ArtworkDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ArtworkDetailViewModel()
    
    let objectID: Int
    
    @State private var showTagSelector = false
    @State private var showCustomTagInput = false
    @State private var customTagName = ""
    @State private var isImageFullScreen = false
    
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
                AsyncImage(url: URL(string: artwork.primaryImage)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                            .onTapGesture { isImageFullScreen = true }
                    } else if phase.error != nil {
                        Color.gray
                            .frame(height: 300)
                            .overlay {
                                Image(systemName: "photo")
                                    .font(.largeTitle)
                            }
                    } else {
                        ProgressView()
                            .frame(height: 300)
                    }
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(artwork.title)
                        .font(.title2.bold())
                    
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
                
                Button(action: { showTagSelector = true }) {
                    HStack {
                        Text(viewModel.isCollected ?
                             "Tagged as \(viewModel.selectedTag?.emoji ?? "❤️")" :
                             "Add to Collection")
                        Spacer()
                        Image(systemName: viewModel.isCollected ? "checkmark.circle.fill" : "plus.circle")
                    }
                    .padding()
                    .background(viewModel.isCollected ? Color.green.opacity(0.2) : Color.blue.opacity(0.2))
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
        if !value.isEmpty {
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
        } else {
            return AnyView(EmptyView())
        }
    }

    private func tagSelectionSheet() -> some View {
        NavigationStack {
            List {
                Section("My Tags") {
                    ForEach(viewModel.recentTags, id: \.name) { tag in
                        HStack {
                            Button {
                                viewModel.toggleFavorite(with: tag)

//                                let item = FavoriteItem(objectID: objectID, tagName: tag.name)
//                                try? modelContext.save()
//                                modelContext.insert(item)
                                let item = FavoriteItem(objectID: objectID, tagName: tag.name)
                                // ↓ objectID 是 Int，模型会自动转成 objectIDString: String
                                modelContext.insert(item)
                                try? modelContext.save()

                                showTagSelector = false
                            } label: {
                                HStack {
                                    Text(tag.emoji)
                                    Text(tag.name)
                                    Spacer()
                                    if viewModel.isCollected && viewModel.selectedTag == tag {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                            
                            Button {
                                viewModel.deleteTag(tag)
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(.borderless)
                        }
                    }
                }
                
                Section {
                    Button {
                        showCustomTagInput = true
                        showTagSelector = false
                    } label: {
                        Label("Custom Tag", systemImage: "plus")
                    }
                }
                
                if viewModel.isCollected {
                    Section {
                        Button(role: .destructive) {
                            viewModel.removeFavorite()
                            
                            let idString = String(objectID)
                            if let existing = try? modelContext.fetch(
                                FetchDescriptor<FavoriteItem>(
                                    predicate: #Predicate { $0.objectIDString == idString }
                                )
                            ).first {
                                modelContext.delete(existing)
                                try? modelContext.save()
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
        viewModel.toggleFavorite(with: newTag)
        
        let item = FavoriteItem(objectID: objectID, tagName: newTag.name)
        modelContext.insert(item)
        try? modelContext.save()

        customTagName = ""
    }
}

    
//    private func confirmCustomTag() {
//        guard !customTagName.isEmpty else { return }
//        let newTag = FavoriteTag(emoji: "🔖", name: customTagName)
//        viewModel.toggleFavorite(with: newTag)
//        customTagName = ""
//    }
    


//#Preview {
//    NavigationStack {
//        ArtworkDetailView(objectID: 436535)
//    }
//}
