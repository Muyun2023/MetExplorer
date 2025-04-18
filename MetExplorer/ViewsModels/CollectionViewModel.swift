//  CollectionViewModel.swift
//  MetExplorer

import Foundation
import SwiftData
import Observation

@Observable
final class CollectionViewModel {
    var favoriteArtworks: [Artwork] = []

    func refreshFavorites(context: ModelContext) async {
        do {
            let favorites = try context.fetch(FetchDescriptor<FavoriteItem>())
            //let ids = favorites.map { $0.objectID }
            let ids = favorites.compactMap { Int($0.objectIDString) } // ✅ 避免访问 computed 属性

            var loaded: [Artwork] = []
            for id in ids {
                do {
                    let artwork = try await MetMuseumAPI.shared.fetchArtwork(by: id)
                    loaded.append(artwork)
                } catch {
                    print("Failed to load artwork \(id): \(error)")
                }
            }

            favoriteArtworks = loaded
        } catch {
            print("Failed to fetch favorites from SwiftData: \(error)")
        }
    }

    func tagEmoji(for objectID: Int) -> String {
        "❤️"
    }
}

