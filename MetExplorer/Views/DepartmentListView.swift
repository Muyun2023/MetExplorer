//  DepartmentListView.swift
//  MetExplorer

import SwiftUI

// Main view displaying the list of departments
struct DepartmentListView: View {
    private let viewModel = DepartmentViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.departments) { department in
                NavigationLink(destination: ArtworkListView(departmentId: department.departmentId)) {
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
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.white).shadow(radius: 5))
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
                        Task { await viewModel.loadDepartments() }
                    }
                }
            }
        }
    }
    
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
