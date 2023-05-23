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
    
    public func execute(_ request: RMRequest, onComplete: @escaping () -> Void) {
        
    }
}
