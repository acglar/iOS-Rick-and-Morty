//
//  RMPhotoCollectionViewCellViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 5.06.2023.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    private let imageUrl: URL?
    
    init(imageUrl: URL?) {
        self.imageUrl = imageUrl
    }
    
    public func fetchImage(onComplete: @escaping (Result<Data, Error>) -> Void) {
        guard let url = imageUrl else {
            onComplete(.failure(URLError(.badURL)))
            return
        }
        
        ImageLoader.instance.downloadImage(url, onComplete: onComplete)
    }
}
