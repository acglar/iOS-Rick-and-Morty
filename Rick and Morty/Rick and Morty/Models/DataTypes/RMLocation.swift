//
//  RMLocation.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 22.05.2023.
//

import Foundation

struct RMLocation: Codable {
    let id: Int
    let name: String
    let type: String
    let dimension: String
    let residents: [String]
    let url: String
    let created: String
}
