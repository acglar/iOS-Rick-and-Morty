//
//  RMAPICacheManager.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 8.06.2023.
//

import Foundation

final class RMAPICacheManager {
    private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    init() {
        setUpCache()
    }
    
    // MARK: - Public
    
    public func cachedResponse(for endPoint: RMEndpoint, url: URL?) -> Data? {
        guard let targetCache = cacheDictionary[endPoint],
              let url = url else { return nil }
        
        let key = url.absoluteString as NSString
        return targetCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endPoint: RMEndpoint, url: URL?, data: Data) {
        guard let targetCache = cacheDictionary[endPoint],
              let url = url else { return }
        
        let key = url.absoluteString as NSString
        targetCache.setObject(data as NSData, forKey: key)
    }
    
    
    // MARK: - Private
    
    private func setUpCache() {
        RMEndpoint.allCases.forEach { endPoint in
            cacheDictionary[endPoint] = NSCache<NSString, NSData>()
        }
    }
    
}
