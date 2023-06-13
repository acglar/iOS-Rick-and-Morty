//
//  RMLocationTableViewCellViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 12.06.2023.
//

import UIKit

struct RMLocationTableViewCellViewModel: Hashable, Equatable {
    private let location: RMLocation
    
    init(location: RMLocation) {
        self.location = location
    }
    
    public var name: String {
        return location.name
    }
    
    public var type: String {
        return "Type: \(location.type)"
    }
    
    public var dimension: String {
        return location.dimension
    }
    
    // MARK: - Hashable
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(location.id)
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
