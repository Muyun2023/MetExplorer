//  MetExplorerApp.swift
//  MetExplorer

import SwiftUI
import SwiftData

@main
struct MetExplorerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FavoriteItem.self) // ✅ 添加这行
    }
}

