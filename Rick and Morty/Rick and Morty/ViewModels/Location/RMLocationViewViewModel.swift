//
//  RMLocationViewViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 12.06.2023.
//

import UIKit

protocol RMLocationViewViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewViewModel {
    public weak var delegate: RMLocationViewViewModelDelegate?
    
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }
    
    private var apiInfo: RMGetAllLocationsResponse.Info?
    
    private var hasMoreResults: Bool {
        guard let info = apiInfo else { return false}
        return info.next != nil
    }
    
    public func location(at index: Int) -> RMLocation? {
        if index >= locations.count {
            return nil
        }
        
        return locations[index]
    }
    
    public func fetchLocations() {
        RMService.instance.execute(.listLocationsRequest, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                break
            }
        }
    }
    
}
