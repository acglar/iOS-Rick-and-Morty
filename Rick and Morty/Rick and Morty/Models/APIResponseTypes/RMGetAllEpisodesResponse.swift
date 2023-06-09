//
//  RMGetAllEpisodesResponse.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 9.06.2023.
//

import Foundation

struct RMGetAllEpisodesResponse: Codable {
    let info: Info
    let results: [RMEpisode]
    
    struct Info: Codable {
        let count: Int
        let pages: Int
        let next: String?
        let prev: String?
    }
}
