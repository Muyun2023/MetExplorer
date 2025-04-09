//
//  DepartmentViewModel.swift
//  MetExplorer

import SwiftUI
import Observation

// ViewModel that handles fetching and storing department data
@Observable
class DepartmentViewModel {
    var departments: [Department] = []
    var isLoading = false // Flag to show loading indicator
    // Automatically fetch departments when the ViewModel is created
    init() {
        Task {
            await fetchDepartments()
        }
    }

    // Fetch departments using async/await
    func fetchDepartments() async {
        isLoading = true
        do {
            let result = try await MetMuseumAPI.shared.fetchDepartments()
            self.departments = result
        } catch {
            print("Error fetching departments: \(error)")
        }
        isLoading = false
    }
}
