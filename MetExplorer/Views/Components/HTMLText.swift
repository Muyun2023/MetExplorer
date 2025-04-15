//
//  SafeText.swift
//  MetExplorer
//

import SwiftUI

func attributedString(from html: String) -> AttributedString {
    guard let data = html.data(using: .utf16) else {
        return AttributedString("Invalid text")
    }

    do {
        let nsAttrStr = try NSAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil
        )
        return AttributedString(nsAttrStr)
    } catch {
        return AttributedString("Error parsing")
    }
}

struct HTMLText: View {
    let html: String
    
    var body: some View {
        Text(attributedString(from: html))
    }
}


