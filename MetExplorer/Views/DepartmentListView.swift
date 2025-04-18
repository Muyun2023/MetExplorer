//  Views/DepartmentListView.swift
//  MetExplorer

import SwiftUI

/// Displays the list of departments from the Met API.
struct DepartmentListView: View {
    private let viewModel = DepartmentViewModel()
    
    var body: some View {
        NavigationStack {
            List(viewModel.departments) { department in
                NavigationLink(
                    destination: ArtworkListView(
                        departmentId: department.departmentId,
                        departmentName: department.displayName
                    )
                ) {
                    HStack {
                        Image(iconName(for: department))
                            .resizable()
                            .frame(width: 40, height: 40)
                            .font(.title)
                            .padding()

                        Text(department.displayName)
                            .font(.title3)
                            .fontWeight(.medium)
                            .foregroundColor(.primary)
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical, 8)

                        Spacer()
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(radius: 5)
                    )
                    .padding(.vertical, 4)
                }
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Departments")
            .background(Color(UIColor.systemBackground))
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task {
                            await viewModel.loadDepartments()
                        }
                    }
                }
            }
        }
    }

    /// Fallback error view with retry button
    struct ErrorView: View {
        let message: String
        var retryAction: () -> Void
        
        var body: some View {
            VStack {
                Text("⚠️ " + message)
                    .padding()
                Button("Retry", action: retryAction)
                    .buttonStyle(.borderedProminent)
            }
        }
    }
}
