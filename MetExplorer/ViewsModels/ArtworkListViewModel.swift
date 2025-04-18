//  ArtworkListViewModel.swift
//  MetExplorer
//

import Foundation
import Observation

@Observable
@MainActor
final class ArtworkListViewModel {
    private(set) var artworks: [Artwork] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    var searchText = ""

    /// Filtered artworks based on current search text
    var filteredArtworks: [Artwork] {
        if searchText.isEmpty {
            return artworks
        } else {
            return artworks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }

    /// Fetch artworks from a given department and update local state.
    func fetchArtworks(departmentId: Int) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let ids = try await MetMuseumAPI.shared.fetchObjectIDs(for: departmentId)
            artworks = try await loadFilteredArtworks(ids: ids.shuffled())
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }

    /// Attempt to load artworks from a shuffled list of object IDs.
    /// - Only keeps artworks with available `primaryImageSmall`
    /// - Stops after collecting 20 valid artworks or checking 50 total
    private func loadFilteredArtworks(ids: [Int]) async throws -> [Artwork] {
        var loadedArtworks: [Artwork] = []
        
        for id in ids.prefix(50) {
            do {
                let artwork = try await MetMuseumAPI.shared.fetchArtwork(by: id)
                if !artwork.primaryImageSmall.isEmpty {
                    loadedArtworks.append(artwork)
                    if loadedArtworks.count >= 20 { break }
                }
            } catch {
                print("Skipping artwork \(id): \(error.localizedDescription)")
            }
        }
        
        return loadedArtworks
    }

    /// Handle errors and reset artwork list.
    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            errorMessage = apiError.errorDescription
        } else {
            errorMessage = "Failed to load artworks. Please check your search."
        }
        artworks = []
    }
}
