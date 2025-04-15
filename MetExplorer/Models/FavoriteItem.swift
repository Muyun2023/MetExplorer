//
//  FavoriteItem.swift
//  MetExplorer

import Foundation
import SwiftData

@Model
final class FavoriteItem {
    // 🧩 用 String 代替 Int，避免 CoreData 类型不兼容
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
