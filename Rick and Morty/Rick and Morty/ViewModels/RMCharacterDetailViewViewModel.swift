//
//  RMCharacterDetailViewViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 2.06.2023.
//

import Foundation

final class RMCharacterDetailViewViewModel {
    private let character: RMCharacter
    
    init(character: RMCharacter) {
        self.character = character
    }
    
    public var title: String {
        return character.name.uppercased()
    }
}
