// FavoriteItem.swift
// MetExplorer

import Foundation
import SwiftData

/// SwiftData model representing a favorited artwork and its associated tag.
@Model
class FavoriteItem {
    @Attribute(.unique) var objectIDString: String
    var tagName: String
    var title: String
    var thumbnailURL: String?

    init(objectIDString: String, tagName: String = "", title: String = "", thumbnailURL: String? = nil) {
        self.objectIDString = objectIDString
        self.tagName = tagName
        self.title = title
        self.thumbnailURL = thumbnailURL
    }
}

