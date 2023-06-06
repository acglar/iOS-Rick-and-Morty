//
//  RMInfoCollectionViewCellViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 5.06.2023.
//

import Foundation

final class RMCharacterInfoCollectionViewCellViewModel {
    public let value: String
    public let title: String
    
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}
