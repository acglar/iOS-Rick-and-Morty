//
//  RMCharacterDetailViewViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 2.06.2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    enum SectionType: CaseIterable {
        case photo
        case information
        case episodes
    }
    
    public let sections = SectionType.allCases

    // MARK: - Init
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        return character.name.uppercased()
    }
    
    private var requestUrl: URL? {
        return URL(string: character.url)
    }
}
