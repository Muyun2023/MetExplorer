//  RefreshButton.swift
//  MetExplorer

import SwiftUI

struct ShuffledButton: View {
    var action: () -> Void
    var label: String = "Shuffle"

    var body: some View {
        Button(action: action) {
            Label(label, systemImage: "arrow.triangle.2.circlepath")
                .labelStyle(IconOnlyLabelStyle())
                .padding(8)
                .background(Color.blue.opacity(0.15))
                .clipShape(Circle())
                .foregroundColor(.blue)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


