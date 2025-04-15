//  DepartmentViewModel.swift
//  MetExplorer

import Foundation
import Observation

@Observable
@MainActor
final class DepartmentViewModel {
    private(set) var departments: [Department] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?
    
    init() {
        Task { await loadDepartments() }
    }
    
    func loadDepartments() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await MetMuseumAPI.shared.fetchDepartments()
            departments = result
        } catch {
            handleError(error)
        }
        
        isLoading = false
    }
    
    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            errorMessage = apiError.errorDescription
        } else {
            errorMessage = "Failed to load departments. Please try later."
        }
        departments = []
    }
}

/**
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
 */
