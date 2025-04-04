//  DepartmentListView.swift
//  MetExplorer

import SwiftUI

class DepartmentViewModel: ObservableObject {
    @Published var departments: [Department] = []
    @Published var isLoading = false

    init() {
        fetchDepartments()
    }

    func fetchDepartments() {
        isLoading = true
        MetMuseumAPI.shared.fetchDepartments { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let departments):
                    self.departments = departments
                case .failure(let error):
                    print("Error fetching departments: \(error)")
                }
            }
        }
    }
}

struct DepartmentListView: View {
    @StateObject private var viewModel = DepartmentViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.departments) { department in
                //Text(department.displayName)
                HStack{
                    //Image(systemName: "photo.fill")
                    Image(systemName: "paintpalette")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        //.font(.title)
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
                .padding(.vertical,4)
            }
            .listStyle(PlainListStyle())
            .navigationTitle("Departments")
            .background(Color(UIColor.systemBackground))
            .overlay(
                Group {
                    if viewModel.isLoading {
                        ZStack{
                            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
                            ProgressView("Loading...").progressViewStyle(CircularProgressViewStyle(tint: .white))
                        }
                    }
                }
            )
        }
        .accentColor(.blue)
    }
}

struct DepartmentListView_Previews: PreviewProvider {
    static var previews: some View {
        DepartmentListView()
    }
}


