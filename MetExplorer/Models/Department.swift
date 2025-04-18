// Department.swift
// MetExplorer

import Foundation

/// Represents a department within the Met Museum.
struct Department: Codable, Identifiable, Hashable {
    let departmentId: Int
    let displayName: String
    var id: Int { departmentId }

    // Conforms to Hashable by combining department ID
    func hash(into hasher: inout Hasher) {
        hasher.combine(departmentId)
    }
}

/// Response wrapper for department API call
struct DepartmentResponse: Codable {
    let departments: [Department]
}
