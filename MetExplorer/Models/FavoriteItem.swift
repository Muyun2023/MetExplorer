// FavoriteItem.swift
// MetExplorer

import Foundation
import SwiftData

/// SwiftData model representing a favorited artwork and its associated tag.
@Model
final class FavoriteItem {
    /// The artwork's object ID as a string (stored this way for compatibility with SwiftData/CoreData)
    var objectIDString: String

    /// The tag name associated with this favorite (e.g., "Favorite", "Cool")
    var tagName: String

    init(objectID: Int, tagName: String = "") {
        self.objectIDString = String(objectID)
        self.tagName = tagName
    }

    /// Computed property to convert objectIDString back to Int
    var objectID: Int {
        Int(objectIDString) ?? -1
    }
}
