//  Department.swift
//  MetExplorer

import Foundation

// Model for a department returned from the API
struct Department: Codable, Identifiable {
    let departmentId: Int         // Unique ID for the department
    let displayName: String       // Display name of the department
    var id: Int { departmentId }  // Conform to Identifiable by using departmentId as id
}

// Model for the full JSON response containing department array
struct DepartmentResponse: Codable {
    let departments: [Department]
}


