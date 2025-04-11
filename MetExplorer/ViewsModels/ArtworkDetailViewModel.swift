//  ArtworkDetailViewModel.swift
//  MetExplorer

import Foundation
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
    }





