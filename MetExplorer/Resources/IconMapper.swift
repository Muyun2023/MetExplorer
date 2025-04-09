//  IconMapper.swift
//  MetExplorer

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
