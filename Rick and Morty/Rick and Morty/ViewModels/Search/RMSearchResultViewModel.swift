//
//  RMSearchResultViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 16.06.2023.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
