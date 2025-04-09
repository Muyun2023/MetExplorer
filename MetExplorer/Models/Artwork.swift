//  Artwork.swift
//  MetExplorer

import Foundation

struct Artwork:Codable,Identifiable{
    let objectID:Int
    let title:String
    let artistDisplayName:String
    let primaryImageSmall:String
    let culture:String?
    var id:Int{objectID}
}




