//  IconMapper.swift
//  MetExplorer

// Dictionary mapping departmentId to asset image names
let departmentIcons: [Int: String] = [
    1: "American Decorative Art",
    //2: "Ancient Near Eastern Art", //? not work
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
    13: "Greek and Roman Art",
    14: "Islamic Art",
    15: "The robert lehman collection",
    16: "The Libraries",
    17: "Medieval Art",
    18: "Musical Instruments",
    19: "Photographs",
    //20: "Modern Art" //? not work
    21: "Modern Art"
]

// Return the correct icon name for a given department
func iconName(for department: Department) -> String {
    return departmentIcons[department.departmentId] ?? "The metropolitan Museum of Art"
}
