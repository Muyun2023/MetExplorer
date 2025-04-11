//  FavoriteManager.swift
//  MetExplorer

import Foundation
import Observation

@Observable
class FavoriteViewModel {
    static let shared = FavoriteViewModel()
    
    private(set) var favorites: [Int: String] = [:]
    private(set) var recentTags: [String] = []

    private let favoritesKey = "favorites"
    private let recentTagsKey = "recentTags"

    private init() {
        loadFavorites()
        loadRecentTags()
    }

    func isFavorite(objectID: Int) -> Bool {
        favorites[objectID] != nil
    }

    func tag(for objectID: Int) -> String? {
        favorites[objectID]
    }

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

    func removeFromFavorites(objectID: Int) {
        favorites.removeValue(forKey: objectID)
        saveFavorites()
    }

    private func saveFavorites() {
        UserDefaults.standard.set(favorites, forKey: favoritesKey)
    }

    private func loadFavorites() {
        if let saved = UserDefaults.standard.dictionary(forKey: favoritesKey) as? [Int: String] {
            favorites = saved
        }
    }

    private func saveRecentTags() {
        UserDefaults.standard.set(recentTags, forKey: recentTagsKey)
    }

    private func loadRecentTags() {
        if let saved = UserDefaults.standard.stringArray(forKey: recentTagsKey) {
            recentTags = saved
        }
    }
}
