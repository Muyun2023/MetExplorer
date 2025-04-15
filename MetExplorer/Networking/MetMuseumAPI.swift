import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case dataCorrupted
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "Invalid museum API endpoint"
        case .dataCorrupted: return "Artwork data might be changed"
        case .serverError(let code): return "Server error (Code: \(code))"
        }
    }
}

actor MetMuseumAPI {
    static let shared = MetMuseumAPI()
    private init() {}
    
    private let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1/"
    
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

    func fetchDepartments() async throws -> [Department] {
        let response: DepartmentResponse = try await fetch(endpoint: "departments")
        return response.departments
    }

    func fetchObjectIDs(for departmentId: Int) async throws -> [Int] {
        struct ObjectIDResponse: Decodable {
            let objectIDs: [Int]?
        }

        let response: ObjectIDResponse = try await fetch(endpoint: "objects?departmentIds=\(departmentId)")
        return response.objectIDs ?? []
    }

    func fetchArtwork(by id: Int) async throws -> Artwork {
        try await fetch(endpoint: "objects/\(id)")
    }
}





/**
 // Define API base URL
struct API {
    static let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1/"
}

// Handles network requests to the Met Museum API
class MetMuseumAPI {
    static let shared = MetMuseumAPI()  // Singleton instance
    
    // Asynchronously fetch departments from the API
    func fetchDepartments() async throws -> [Department] {
        let urlString = "\(API.baseURL)departments" 
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)  // Throw an error if URL is invalid
        }
        
        // Send GET request and receive response data
        let (data, _) = try await URLSession.shared.data(from: url)
        
        // Decode JSON into DepartmentResponse, then return the departments array
        let response = try JSONDecoder().decode(DepartmentResponse.self, from: data)
        return response.departments
    }
}

extension MetMuseumAPI {
    func fetchObjectIDs(for departmentId: Int) async throws -> [Int] {
        let urlString = "\(API.baseURL)objects?departmentIds=\(departmentId)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        struct ObjectResponse: Codable {
            let objectIDs: [Int]?
        }
        
        let response = try JSONDecoder().decode(ObjectResponse.self, from: data)
        return response.objectIDs ?? []
    }

    func fetchArtwork(by id: Int) async throws -> Artwork {
        let urlString = "\(API.baseURL)objects/\(id)"
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)

        return try JSONDecoder().decode(Artwork.self, from: data)
    }
}
 */


/**
 class MetMuseumAPI {
     static let shared = MetMuseumAPI()  // Singleton instance of MetMuseumAPI

     // Fetch departments from the API
     func fetchDepartments(completion: @escaping (Result<[Department], Error>) -> Void) {
         let urlString = "\(API.baseURL)departments"  // Construct the full URL for departments
         guard let url = URL(string: urlString) else { return }  // Ensure the URL is valid

         // Perform a network request to fetch data
         URLSession.shared.dataTask(with: url) { data, response, error in
             if let error = error {  // Handle any error that occurs during the request
                 completion(.failure(error))
                 return
             }

             guard let data = data else { return }  // Ensure data is not nil

             do {
                 // Decode the JSON response into DepartmentResponse object
                 let response = try JSONDecoder().decode(DepartmentResponse.self, from: data)
                 completion(.success(response.departments))  // Pass the array of departments to the completion handler
             } catch {
                 completion(.failure(error))  // Handle any decoding errors
             }
         }.resume()  // Start the network request
     }
 }
 */







