//  ArtworkListViewModel.swift
//  MetExplorer

import SwiftUI
import Observation

@Observable
class ArtworkListViewModel{
    var artworks:[Artwork]=[]
    var isLoading=false
    
    func fetchArtworks(departmentId:Int)async{
        isLoading=true
        do{
            let ids=try await MetMuseumAPI.shared.fetchObjectIDs(for: departmentId)
            let first20=ids.prefix(20)
            var temp:[Artwork]=[]
            for id in first20{
                do{
                    let art=try await MetMuseumAPI.shared.fetchArtwork(by: id)
                    temp.append(art)
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
}

