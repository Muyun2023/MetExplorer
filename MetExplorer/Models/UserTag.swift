// FavoriteTagItem.swift
// MetExplorer

import Foundation
import SwiftData

/// Represents a user-defined tag stored in SwiftData.
@Model
final class UserTag {
    var name: String    // Tag name
    var emoji: String   // Emoji associated with the tag

    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
    }
}
