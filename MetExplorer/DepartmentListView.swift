//  DepartmentListView.swift
//  MetExplorer

import SwiftUI

class DepartmentViewModel: ObservableObject{
    @Published var departments: [Department] = []
    @Published var isLoading = false
    
    init(){
        fetchDepartments()
    }
    
    func fetchDepartments(){
        isLoading = true
        MetMuseumAPI.shared.fetchDepartments{ result in
            DispatchQueue.main.async{
                self.isLoading = false
                switch result {
                case .success(let departments):
                    self.departments = departments
                case .failure(let error):
                    print("Erro fetching departments: \(error)")
                }
            }
        }
    }
}

struct DepartmentListView: View {
    @StateObject private var viewModel = DepartmentViewModel()
    
    var body: some View {
        NavigationView{
            List(viewModel.departments){department in
                Text(department.displayName)
            }
            .navigationTitle("Departments")
            .overlay(
                Group{
                    if viewModel.isLoading{
                        ProgressView("Loading...")
                    }
                }
            )
        }
    }
}

struct DepartmentListView_Previews:PreviewProvider{
    static var previews:some View{
        DepartmentListView()
    }
}


