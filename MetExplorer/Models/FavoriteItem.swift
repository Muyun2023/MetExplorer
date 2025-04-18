//
//  FavoriteItem.swift
//  MetExplorer

import Foundation
import SwiftData

@Model
final class FavoriteItem {
    var objectIDString: String
    var tagName: String

    init(objectID: Int, tagName: String = "") {
        self.objectIDString = String(objectID)
        self.tagName = tagName
    }

    var objectID: Int {
        Int(objectIDString) ?? -1
    }
}
