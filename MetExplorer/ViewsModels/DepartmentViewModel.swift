//  DepartmentViewModel.swift
//  MetExplorer


import Foundation
import Observation

/// ViewModel responsible for loading and managing department data
@Observable
@MainActor
final class DepartmentViewModel {
    
    /// List of departments fetched from the API
    private(set) var departments: [Department] = []
    
    /// Indicates whether data is currently being fetched
    private(set) var isLoading = false
    
    /// Stores any error messages encountered during loading
    private(set) var errorMessage: String?
    
    /// Automatically load departments when the view model is initialized
    init() {
        Task { await loadDepartments() }
    }
    
    /// Fetch departments asynchronously from the API
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
    
    /// Handle API or unexpected errors and reset state
    private func handleError(_ error: Error) {
        if let apiError = error as? APIError {
            errorMessage = apiError.errorDescription
        } else {
            errorMessage = "Failed to load departments. Please try later."
        }
        departments = []
    }
}
