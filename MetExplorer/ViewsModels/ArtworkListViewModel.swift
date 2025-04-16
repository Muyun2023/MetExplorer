//  ArtworkListViewModel.swift
//  MetExplorer

import Foundation
import Observation

@Observable
@MainActor
final class ArtworkListViewModel {
    private(set) var artworks: [Artwork] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    var searchText = ""
    
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
    
    var filteredArtworks: [Artwork] {
        if searchText.isEmpty {
            return artworks
        } else {
            return artworks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    func filteredArtworks(searchText: String) -> [Artwork] {
        if searchText.isEmpty {
            return artworks
        } else {
            return artworks.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
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
    
    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            errorMessage = apiError.errorDescription
        } else {
            errorMessage = "Failed to load artworks. Please check your search."
        }
        artworks = []
    }
}

/**import Foundation
import Observation

@Observable
class ArtworkListViewModel{
    var artworks:[Artwork]=[]
    var isLoading=false
    
    func fetchArtworks(departmentId:Int)async{
        isLoading=true
        defer{isLoading=false}
        
        do{
            let ids=try await MetMuseumAPI.shared.fetchObjectIDs(for: departmentId)
            //let filtered=ids.prefix(100)
            let shuffled=ids.shuffled()
            var temp:[Artwork]=[]
            
            for id in shuffled.prefix(50){
                do{
                    let art=try await MetMuseumAPI.shared.fetchArtwork(by: id)
                    if !art.primaryImageSmall.isEmpty{
                        temp.append(art)
                    }
                    if temp.count>=20{
                        break
                    }
                }catch{
                    print("Error loading artwork \(id): \(error)")
                }
            }
            self.artworks=temp
        }catch{
            print("Error fetching artworks for department \(departmentId): \(error)")
        }
        isLoading=false
    }
    
} */

    
    /**
     // Some artworks' images are unavilable; checking shows they don't supply Images
     
     func fetchArtworks(departmentId: Int) async {
     isLoading = true
     do {
     let ids = try await MetMuseumAPI.shared.fetchObjectIDs(for: departmentId)
     print("🎯 get \(ids.count) object IDs，department ID：\(departmentId)")
     
     let first20 = ids.prefix(20)
     var temp: [Artwork] = []
     
     for id in first20 {
     do {
     let art = try await MetMuseumAPI.shared.fetchArtwork(by: id)
     print("🖼️ Artwork ID \(id): \(art.title)")
     print("    Artwork Image Link : \(art.primaryImageSmall.isEmpty ? "❌ None Image" : "✅ Have Image")")
     temp.append(art)
     } catch {
     print("❗Loading Artwork \(id) error: \(error)")
     }
     }
     self.artworks = temp
     } catch {
     print("❗Get artworks error: \(error)")
     }
     isLoading = false
     }
     
     }
     
     // Solution1:
     for id in filtered{
         do{
             let art=try await MetMuseumAPI.shared.fetchArtwork(by: id)
             if art.primaryImageSmall.isEmpty{
                 print("Skip Artwork \(id): No Image")
                 continue
             }
             temp.append(art)
         }catch{
             print("Error loading artwork \(id): \(error)")
         }
     }
     // Then An apartment's all 20 artworks don't have images will show nothing on screen
     
     */
    

