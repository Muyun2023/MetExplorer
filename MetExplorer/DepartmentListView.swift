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

// Main view displaying the list of departments
struct DepartmentListView: View {
    @State private var viewModel = DepartmentViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.departments) { department in
                HStack {
                    Image(systemName: "paintpalette") //Icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .font(.title)
                        .padding()
                    
                    Text(department.displayName) //Information
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

// Preview for SwiftUI canvas
#Preview {
    DepartmentListView()
}
