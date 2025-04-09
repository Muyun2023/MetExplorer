//  Artwork.swift
//  MetExplorer

import Foundation

struct Artwork: Identifiable, Codable {
    let objectID: Int
    var id: Int { objectID }
    
    let title: String
    let artistDisplayName: String
    let objectDate: String
    let primaryImage: String
    let primaryImageSmall: String
    let medium: String
    let culture: String
    let country: String
    let creditLine: String
    let accessionYear: String
    //let department: String
    
    var descriptionText: String {
        var parts: [String] = []
        
        if !culture.isEmpty {
            parts.append("This artwork belongs to the \(culture) culture")
        }
        
        if !country.isEmpty {
            parts.append("and originates from \(country)")
        }
        
        if !accessionYear.isEmpty {
            parts.append(". It was acquired by The Met in \(accessionYear)")
        }
        
        /**if !department.isEmpty {
            parts.append("and is part of the \(department) department")
        }*/
        
        if !creditLine.isEmpty {
            parts.append(". Credit line: \(creditLine)")
        }
        
        let sentence = parts.joined(separator: " ") + "."
        return sentence.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}




