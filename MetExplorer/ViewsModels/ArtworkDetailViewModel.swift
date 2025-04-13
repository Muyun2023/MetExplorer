//  ArtworkDetailViewModel.swift
//  MetExplorer
import Foundation
import Observation

@Observable
final class ArtworkDetailViewModel {
    private(set) var artwork: Artwork?
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    private(set) var isCollected = false
    private(set) var selectedTag: FavoriteTag?
    private(set) var recentTags: [FavoriteTag] = demoTags
    
    @MainActor
    func fetchArtworkDetail(objectID: Int) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            artwork = try await MetMuseumAPI.shared.fetchArtwork(by: objectID)
            checkCollectionStatus()
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    @MainActor
    func toggleFavorite(with tag: FavoriteTag) {
        isCollected = true
        selectedTag = tag
        updateRecentTags(tag)
        // 实际存储操作将在SwiftData迁移后实现
    }
    
    @MainActor
    func removeFavorite() {
        isCollected = false
        selectedTag = nil
    }
    
    @MainActor
    private func checkCollectionStatus() {
        //guard let objectID = artwork?.objectID else { return }
        //_ = objectID
        guard artwork != nil else { return }
        isCollected = false
        selectedTag = nil
    }
    
    @MainActor
    private func updateRecentTags(_ newTag: FavoriteTag) {
        recentTags.removeAll { $0 == newTag }
        recentTags.insert(newTag, at: 0)
        if recentTags.count > 5 {
            recentTags = Array(recentTags.prefix(5))
        }
    }
    
    @MainActor
    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        artwork = nil
    }
}

private let demoTags = [
    FavoriteTag(emoji: "❤️", name: "Favorite"),
    FavoriteTag(emoji: "🌟", name: "Masterpiece"),
    FavoriteTag(emoji: "🎨", name: "Inspiration")
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





