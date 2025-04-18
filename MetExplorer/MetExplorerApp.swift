//  MetExplorerApp.swift
//  MetExplorer

import SwiftUI
import SwiftData

/// Entry point for the MetExplorer app
@main
struct MetExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Enable SwiftData for FavoriteItem and UserTag models
        .modelContainer(for: [FavoriteItem.self, UserTag.self])
    }
}
