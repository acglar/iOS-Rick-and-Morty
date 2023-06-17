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
    
    public var isLoadingMoreLocations = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
    
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
    
    private var didFinishPagination: (() -> Void)?
    
    public func location(at index: Int) -> RMLocation? {
        if index >= locations.count {
            return nil
        }
        
        return locations[index]
    }
    
    public func registerDidFinishPagination(_ block: @escaping () -> Void) {
        self.didFinishPagination = block
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
            case .failure:
                break
            }
        }
    }
    
    public func fetchAdditionalLocations() {
        if isLoadingMoreLocations { return }
        
        guard let nextUrlString = apiInfo?.next,
              let url = URL(string: nextUrlString),
              let request = RMRequest(url: url) else { return }
        
        isLoadingMoreLocations = true
        
        RMService.instance.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info

                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap({
                    return RMLocationTableViewCellViewModel.init(location: $0)
                }))
                
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false
                    strongSelf.didFinishPagination?()
                    
                }
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingMoreLocations = false
            }
        }
    }
    
}
