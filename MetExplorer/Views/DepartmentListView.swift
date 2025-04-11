//  DepartmentListView.swift
//  MetExplorer

import SwiftUI

// Main view displaying the list of departments
struct DepartmentListView: View {
    @State private var viewModel = DepartmentViewModel()
    
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
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ZStack {
                            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                            ProgressView("Loading...")
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                }
            )
        }
    }
}


