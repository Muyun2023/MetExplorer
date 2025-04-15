//  Department.swift
//  MetExplorer

import Foundation

// 添加 Hashable 协议一致性
struct Department: Codable, Identifiable, Hashable {
    let departmentId: Int
    let displayName: String
    var id: Int { departmentId }
    
    // 实现 Hashable 协议（自动合成即可）
    func hash(into hasher: inout Hasher) {
        hasher.combine(departmentId)
    }
}

// 保持原有 DepartmentResponse
struct DepartmentResponse: Codable {
    let departments: [Department]
}

