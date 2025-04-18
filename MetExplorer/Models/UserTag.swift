//
//  FavoriteTagItem.swift
//  MetExplorer

import Foundation
import SwiftData

@Model
final class UserTag{
    var name: String
    var emoji: String

    init(name: String, emoji: String) {
        self.name = name
        self.emoji = emoji
    }
}

