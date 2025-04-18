//
//  ContentView.swift
//  MetExplorer
//

import SwiftUI

/// Main entry point of the app with a tab-based layout
struct ContentView: View {
    var body: some View {
        TabView {
            // 🔍 Tab 1: Department search
            NavigationStack {
                DepartmentListView()
            }
            .tabItem {
                Label("Find", systemImage: "magnifyingglass")
            }
            
            // Tab 2: User's collection of artworks
            NavigationStack {
                CollectionView()
            }
            .tabItem {
                Label("Collection", systemImage: "heart.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
