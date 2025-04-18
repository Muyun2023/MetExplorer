//  CollectionViewModel.swift
//  MetExplorer


import Foundation
import SwiftData
import Observation

@Observable
final class CollectionViewModel {
    /// List of artworks currently marked as favorites
    var favoriteArtworks: [Artwork] = []

    /// Refresh and load all favorite artworks from SwiftData
    func refreshFavorites(context: ModelContext) async {
        do {
            // Fetch all saved favorite items
            let favorites = try context.fetch(FetchDescriptor<FavoriteItem>())

            // Extract objectIDs and convert to Int
            let ids = favorites.compactMap { Int($0.objectIDString) }

            // Fetch artwork info based on stored IDs
            var loaded: [Artwork] = []
            for id in ids {
                do {
                    let artwork = try await MetMuseumAPI.shared.fetchArtwork(by: id)
                    loaded.append(artwork)
                } catch {
                    print("Failed to load artwork \(id): \(error)")
                }
            }

            // Update state with loaded artworks
            favoriteArtworks = loaded
        } catch {
            print("Failed to fetch favorites from SwiftData: \(error)")
        }
    }

    /// Returns a default emoji for a given artwork (placeholder for future customization)
    func tagEmoji(for objectID: Int) -> String {
        return "❤️"
    }
}
