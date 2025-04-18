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
                            .frame(width: 50, height: 50)
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
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
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

    /// Friendly error UI with retry action
    struct ErrorView: View {
        let message: String
        var retryAction: () -> Void

        var body: some View {
            VStack(spacing: 16) {
                Image(systemName: "wifi.slash")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue.opacity(0.7))

                Text("Oops! Unable to Load")
                    .font(.title2.bold())

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button {
                    retryAction()
                } label: {
                    Label("Try Again", systemImage: "arrow.clockwise.circle.fill")
                        .font(.headline)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding()
            .contentShape(Rectangle())
        }
    }
}
