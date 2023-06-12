//
//  RMLocationViewViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 12.06.2023.
//

import UIKit

final class RMLocationViewViewModel {
    private var locations: [RMLocation] = []
    private var cellViewModels: [String] = []
    
    private var hasMoreResults: Bool {
        return false
    }
    
    public func fetchLocations() {
        RMService.instance.execute(.listLocationsRequest, expecting: String.self) { result in
            switch result {
            case .success(let model):
                break
            case .failure(let error):
                break
            }
        }
    }
    
}
