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

    func toggleFavorite(with tag: FavoriteTag, context: ModelContext) async {
        isCollected = true
        selectedTag = tag
        updateRecentTags(tag)
        await checkCollectionStatus(context: context)
    }

    func removeFavorite(context: ModelContext) async {
        isCollected = false
        selectedTag = nil
        await checkCollectionStatus(context: context)
    }

    private func checkCollectionStatus(context: ModelContext) async{
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

    private func updateRecentTags(_ newTag: FavoriteTag) {
        recentTags.removeAll { $0 == newTag }
        recentTags.insert(newTag, at: 0)
        if recentTags.count > 5 {
            recentTags = Array(recentTags.prefix(5))
        }
    }

    func deleteTag(_ tag: FavoriteTag) {
        recentTags.removeAll { $0 == tag }
        if selectedTag == tag {
            isCollected = false
            selectedTag = nil
        }
    }

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        artwork = nil
    }
    // ensure the favorite tag not really been deleted and will show again when user re-click my collection button
    func ensureFavoriteExists() {
        let favorite = FavoriteTag(emoji: "❤️", name: "Favorite")
        if !recentTags.contains(favorite) {
            recentTags.insert(favorite, at: 0)
            if recentTags.count > 5 {
                recentTags = Array(recentTags.prefix(5))
            }
        }
    }
}

private let demoTags = [
    FavoriteTag(emoji: "❤️", name: "Favorite"),
]


/**import Foundation
import Observation

@Observable
class ArtworkDetailViewModel {
    var artwork: Artwork? = nil
    var isLoading: Bool = false
    
    var isCollected = false
    var selectedTag: FavoriteTag?
    var recentTags: [FavoriteTag] = [
        FavoriteTag(emoji: "❤️", name: "Favorite"),
        FavoriteTag(emoji: "🌟", name: "Highlight"),
        FavoriteTag(emoji: "🎨 ", name: "Inspiration")
    ]
    
    func fetchArtworkDetail(objectID: Int) async {
        isLoading = true
        do {
            let result = try await MetMuseumAPI.shared.fetchArtwork(by: objectID)
            artwork = result
        } catch {
            print("Error loading detail: \(error)")
        }
        isLoading = false
    }
    
    func toggleFavorite(with tag: FavoriteTag) {
        isCollected = true
        selectedTag = tag
        updateRecentTags(tag)
    }
    
    func removeFavorite() {
        isCollected = false
        selectedTag = nil
    }
    
    func updateRecentTags(_ newTag: FavoriteTag) {
        recentTags.removeAll { $0 == newTag }
        recentTags.insert(newTag, at: 0)
        if recentTags.count > 5 {
            recentTags = Array(recentTags.prefix(5))
        }
    }
    
    func deleteCustomTag(_ tag: FavoriteTag) {
        recentTags.removeAll { $0 == tag }
        if selectedTag == tag {
            selectedTag = nil
            isCollected = false
        }
    }
    
}
 */





