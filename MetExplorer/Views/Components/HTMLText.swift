//
//  HTMLText.swift
//  MetExplorer
//

import SwiftUI

func attributedString(from html: String) async -> AttributedString {
    guard let data = html.data(using: .utf16) else {
        return AttributedString("Invalid text")
    }

    do {
        let nsAttrStr = try NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
        // remove the font of title then can adjust title font/size in ArtworkListView
        nsAttrStr.enumerateAttribute(.font, in: NSRange(location: 0, length: nsAttrStr.length)) { _, range, _ in
            nsAttrStr.removeAttribute(.font, range: range)
        }
        return AttributedString(nsAttrStr)
    } catch {
        return AttributedString("Error parsing")
    }
}

struct HTMLText: View {
    let html: String
    @State private var renderedText: AttributedString?

    var body: some View {
        Group {
            if let rendered = renderedText {
                Text(rendered)
            } else {
                Text("") 
            }
        }
        .task {
            renderedText = await attributedString(from: html)
        }
    }
}




