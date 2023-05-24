//
//  RMGetAllCharactersResponse.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 24.05.2023.
//

import Foundation

struct RMGetAllCharactersResponse: Codable {
    let info: Info
    let results: [RMCharacter]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
