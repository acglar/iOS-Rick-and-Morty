//
//  ImageLoader.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 4.06.2023.
//

import Foundation

final class ImageLoader {
    static let instance = ImageLoader()
    
    private var imageDataCache = NSCache<NSString, NSData>()
    
    private init() {
        
    }
    
    public func downloadImage(_ url: URL, onComplete: @escaping (Result<Data,Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            onComplete(.success(data as Data))
            return
        }
        
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                onComplete(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            onComplete(.success(data))
        }
        task.resume()
    }
}
