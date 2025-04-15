//  CollectionViewModel.swift
//  MetExplorer

import Foundation

@Observable
final class CollectionViewModel {
    private(set) var favoriteArtworks: [Artwork] = []
    private let favoritesKey = "favoriteArtworkIDs"
    
    // 临时模拟数据（实际应从API根据存储的ID获取）
    func refreshFavorites() async {
        let ids = UserDefaults.standard.array(forKey: favoritesKey) as? [Int] ?? []
        
        var loadedArtworks: [Artwork] = []
        for id in ids {
            do {
                let artwork = try await MetMuseumAPI.shared.fetchArtwork(by: id)
                loadedArtworks.append(artwork)
            } catch {
                print("Failed to load favorite artwork \(id): \(error)")
            }
        }
        
        favoriteArtworks = loadedArtworks
    }
    
    // 获取标签emoji（临时实现）
    func tagEmoji(for objectID: Int) -> String {
        let tagName = UserDefaults.standard.string(forKey: "tag_\(objectID)") ?? ""
        return tagName.isEmpty ? "❤️" : "🔖"
    }
}
