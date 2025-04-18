// MetMuseumAPI.swift
// MetExplorer

import Foundation

/// Defines common API errors for networking operations.
enum APIError: Error, LocalizedError {
    case invalidURL
    case dataCorrupted
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid museum API endpoint"
        case .dataCorrupted:
            return "Artwork data might be changed"
        case .serverError(let code):
            return "Server error (Code: \(code))"
        }
    }
}

/// Provides functions to interact with the Met Museum public API.
actor MetMuseumAPI {
    static let shared = MetMuseumAPI()
    
    private init() {}

    private let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1/"
    
    /// Generic function to fetch and decode data from a given endpoint.
    private func fetch<T: Decodable>(endpoint: String) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw APIError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200...299).contains(httpResponse.statusCode) {
            throw APIError.serverError(statusCode: httpResponse.statusCode)
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw APIError.dataCorrupted
        }
    }

    /// Fetches all departments from the Met API.
    func fetchDepartments() async throws -> [Department] {
        let response: DepartmentResponse = try await fetch(endpoint: "departments")
        return response.departments
    }

    /// Fetches object IDs for artworks in a specific department.
    func fetchObjectIDs(for departmentId: Int) async throws -> [Int] {
        struct ObjectIDResponse: Decodable {
            let objectIDs: [Int]?
        }

        let response: ObjectIDResponse = try await fetch(endpoint: "objects?departmentIds=\(departmentId)")
        return response.objectIDs ?? []
    }

    /// Fetches full artwork details by object ID.
    func fetchArtwork(by id: Int) async throws -> Artwork {
        try await fetch(endpoint: "objects/\(id)")
    }
}

