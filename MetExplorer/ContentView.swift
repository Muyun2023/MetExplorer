//  ContentView.swift
//  MetExplorer

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            DepartmentListView()
                .tabItem {
                    Label("Find", systemImage: "magnifyingglass")
                }
            
            CollectionView()
                .tabItem {
                    Label("Collection", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
