//  ArtworkDetailViewModel.swift
//  MetExplorer

import Foundation
import Observation
import SwiftData

@Observable
@MainActor
final class ArtworkDetailViewModel {
    private(set) var artwork: Artwork?
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private(set) var isCollected = false
    private(set) var selectedTag: FavoriteTag?
    private(set) var recentTags: [FavoriteTag] = demoTags

    /// Fetch artwork detail by object ID and update state.
    func fetchArtworkDetail(objectID: Int, context: ModelContext) async {
        guard !isLoading else { return }
        isLoading = true
        errorMessage = nil

        do {
            artwork = try await MetMuseumAPI.shared.fetchArtwork(by: objectID)
            await checkCollectionStatus(context: context)
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    /// Toggle favorite state with a given tag.
    func toggleFavorite(with tag: FavoriteTag, context: ModelContext) async {
        isCollected = true
        selectedTag = tag
        updateRecentTags(tag)
        await checkCollectionStatus(context: context)
    }

    /// Remove favorite status from the current artwork.
    func removeFavorite(context: ModelContext) async {
        isCollected = false
        selectedTag = nil
        await checkCollectionStatus(context: context)
    }

    /// Check if the current artwork has been favorited.
    private func checkCollectionStatus(context: ModelContext) async {
        guard let artwork else { return }

        let idString = String(artwork.objectID)

        do {
            let existing = try context.fetch(FetchDescriptor<FavoriteItem>(
                predicate: #Predicate { $0.objectIDString == idString }
            ))

            if let item = existing.first {
                isCollected = true
                selectedTag = FavoriteTag(emoji: "❤️", name: item.tagName)
            } else {
                isCollected = false
                selectedTag = nil
            }
        } catch {
            print("Failed to check collection status: \(error)")
        }
    }

    /// Update tag list so most recent tag appears first.
    private func updateRecentTags(_ newTag: FavoriteTag) {
        recentTags.removeAll { $0 == newTag }
        recentTags.insert(newTag, at: 0)
        if recentTags.count > 5 {
            recentTags = Array(recentTags.prefix(5))
        }
    }

    /// Delete tag from the UI state if it matches.
    func deleteTag(_ tag: FavoriteTag) {
        recentTags.removeAll { $0 == tag }
        if selectedTag == tag {
            isCollected = false
            selectedTag = nil
        }
    }

    /// Handle error when loading artwork data.
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        artwork = nil
    }

    /// Always ensure "Favorite" tag is visible in recentTags.
    func ensureFavoriteExists() {
        let favorite = FavoriteTag(emoji: "❤️", name: "Favorite")
        if !recentTags.contains(favorite) {
            recentTags.insert(favorite, at: 0)
            if recentTags.count > 5 {
                recentTags = Array(recentTags.prefix(5))
            }
        }
    }

    /// Load user's custom tags from SwiftData storage.
    func loadUserTags(from context: ModelContext) async {
        do {
            let items = try context.fetch(FetchDescriptor<UserTag>())
            let tags = items.map { FavoriteTag(emoji: $0.emoji, name: $0.name) }
            self.recentTags = tags
        } catch {
            print("Failed to load user tags: \(error)")
        }
        ensureFavoriteExists()
    }
}

private let demoTags = [
    FavoriteTag(emoji: "❤️", name: "Favorite")
]
