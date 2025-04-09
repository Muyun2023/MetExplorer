//  ArtworkDetailViewModel.swift
//  MetExplorer

import Foundation
import SwiftUI

@Observable
class ArtworkDetailViewModel {
    var artwork: Artwork? = nil
    var chatGPTDescription: String? = nil
    var isLoading: Bool = false
    
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
}





