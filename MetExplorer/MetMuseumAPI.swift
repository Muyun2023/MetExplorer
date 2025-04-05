//  MetMuseumAPI.swift
//  MetExplorer

import Foundation

struct API {
    static let baseURL = "https://collectionapi.metmuseum.org/public/collection/v1/"
}

struct Department: Codable, Identifiable {
    let departmentId: Int
    let displayName: String
    var id: Int { departmentId }
}

class MetMuseumAPI {
    static let shared = MetMuseumAPI()

    func fetchDepartments(completion: @escaping (Result<[Department], Error>) -> Void) {
        let urlString = "\(API.baseURL)departments"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let response = try JSONDecoder().decode(DepartmentResponse.self, from: data)
                completion(.success(response.departments))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

struct DepartmentResponse: Codable {
    let departments: [Department]
}



