//  FavoriteViewModel.swift
//  MetExplorer
//

import Foundation
import Observation

/// ViewModel that handles storing and retrieving user favorites and tag history using UserDefaults.
/// This is not used in SwiftData-based storage. Kept for reference or alternative local storage.
@Observable
class FavoriteViewModel {
    
    static let shared = FavoriteViewModel()
    
    /// Dictionary mapping object IDs to their associated tag name
    private(set) var favorites: [Int: String] = [:]
    
    /// Recently used tag names
    private(set) var recentTags: [String] = []
    
    private let favoritesKey = "favorites"
    private let recentTagsKey = "recentTags"
    
    private init() {
        loadFavorites()
        loadRecentTags()
    }

    /// Check if an artwork is marked as favorite
    func isFavorite(objectID: Int) -> Bool {
        favorites[objectID] != nil
    }

    /// Get the tag associated with a favorited artwork
    func tag(for objectID: Int) -> String? {
        favorites[objectID]
    }

    /// Add artwork to favorites with a specific tag
    func addToFavorites(objectID: Int, tag: String) {
        favorites[objectID] = tag
        saveFavorites()
        
        if !tag.isEmpty {
            recentTags.removeAll(where: { $0 == tag })
            recentTags.insert(tag, at: 0)
            if recentTags.count > 5 {
                recentTags.removeLast()
            }
            saveRecentTags()
        }
    }

    /// Remove artwork from favorites
    func removeFromFavorites(objectID: Int) {
        favorites.removeValue(forKey: objectID)
        saveFavorites()
    }

    /// Save favorites dictionary to UserDefaults
    private func saveFavorites() {
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }

    /// Load favorites from UserDefaults
    private func loadFavorites() {
        if let saved = UserDefaults.standard.dictionary(forKey: favoritesKey) as? [Int: String] {
            favorites = saved
        }
    }

    /// Save recent tag history to UserDefaults
    private func saveRecentTags() {
        UserDefaults.standard.set(recentTags, forKey: recentTagsKey)
    }

    /// Load recent tag history from UserDefaults
    private func loadRecentTags() {
        if let saved = UserDefaults.standard.stringArray(forKey: recentTagsKey) {
            recentTags = saved
        }
    }
}
