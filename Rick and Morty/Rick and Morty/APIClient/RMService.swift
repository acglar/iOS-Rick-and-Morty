//
//  RMService.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 23.05.2023.
//

import Foundation

final class RMService {
    let instance = RMService()
    
    private init() { }
    
    /// Sends API call
    /// - Parameters:
    ///   - request: Instance of the request
    ///   - type: The of the object we expect to return
    ///   - onComplete: Callback with data or error
    public func execute<T: Codable>(_ request: RMRequest, expecting type: T.Type, onComplete: @escaping (Result<T, Error>) -> Void) {
        
    }
}
