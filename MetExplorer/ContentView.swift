//  ContentView.swift
//  MetExplorer

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                DepartmentListView()
            }
            .tabItem {
                Label("Find", systemImage: "magnifyingglass")
            }
            
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

