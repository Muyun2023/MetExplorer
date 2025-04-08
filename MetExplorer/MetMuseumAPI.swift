//  MetMuseumAPI.swift
//  MetExplorer
import Foundation

// Define API base URL
struct API {
    static let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1/"
}

// Define the Department struct to model department data
struct Department: Codable, Identifiable {
    let departmentId: Int
    let displayName: String
    var id: Int { departmentId }
}

// Define MetMuseumAPI class for handling network requests to the Met Museum API
class MetMuseumAPI {
    static let shared = MetMuseumAPI()  // Singleton instance of MetMuseumAPI

    // Fetch departments from the API
    func fetchDepartments(completion: @escaping (Result<[Department], Error>) -> Void) {
        let urlString = "\(API.baseURL)departments"
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

// Define the response structure that includes an array of departments
struct DepartmentResponse: Codable {
    let departments: [Department]
}




