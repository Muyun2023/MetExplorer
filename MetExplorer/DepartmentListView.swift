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

// Dictionary mapping departmentId to asset image names
let departmentIcons: [Int: String] = [
    1: "American Decorative Art",
    //2: "Ancient Near Eastern Art", //?
    3: "Ancient Near Eastern Art",
    4: "Arms and Armor",
    5: "Arts of Africa",
    6: "Asian Art",
    7: "The Cloisters",
    8: "The Costume Institute",
    9: "Drawing and Prints",
    10: "Egyptian Art",
    11: "European Paintings",
    12: "European Sculpture",
    13: "Greek and Roman Art"
]

// Return the correct icon name for a given department
func iconName(for department: Department) -> String {
    return departmentIcons[department.departmentId] ?? "The metropolitan Museum of Art"
}

// Main view displaying the list of departments
struct DepartmentListView: View {
    @State private var viewModel = DepartmentViewModel()
    var body: some View {
        NavigationView {
            List(viewModel.departments) { department in
                HStack {
                    //Image(systemName: "paintpalette") //Icon
                    Image(iconName(for:department))
                        .resizable()
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


/**func iconName(for department: Department) -> String {
    switch department.departmentId {
    case 1:
        return "American Decorative Art"
    case 2:
        return "Ancient Near Eastern Art"
    case 3:
        return "Arms and Armor"
    case 4:
        return "Arts of Africa"
    case 5:
        return "Asian Art"
    case 6:
        return "The Cloisters"
    case 7:
        return "The Costume Institute"
    case 8:
        return "Drawing and Prints"
    case 9:
        return "Egyptian Art"
    case 10:
        return "European Paintings"
    case 11:
        return "European Sculpture"
    case 12:
        return "Greek and Roman Art"
    default:
        return "icon_default"
    }
}*/
