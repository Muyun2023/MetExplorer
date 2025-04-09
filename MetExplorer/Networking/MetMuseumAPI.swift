import Foundation

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







