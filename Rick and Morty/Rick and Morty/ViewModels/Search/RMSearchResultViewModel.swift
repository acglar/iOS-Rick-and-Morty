//
//  RMSearchResultViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 16.06.2023.
//

import Foundation

final class RMSearchResultViewModel {
    public private(set) var results: RMSearchResultType
    private var next: String?
    
    public private(set) var isLoadingMoreResults = false
    
    public var shouldShowLoadMoreIndicator: Bool {
        return next != nil
    }
    
    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }
    
    public func fetchAdditionalLocations(onComplete: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        if isLoadingMoreResults { return }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString),
              let request = RMRequest(url: url) else { return }
        
        isLoadingMoreResults = true
        
        RMService.instance.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info

                strongSelf.next = info.next
                let additionalLocations = moreResults.compactMap({
                    return RMLocationTableViewCellViewModel.init(location: $0)
                })
                
                var newResults: [RMLocationTableViewCellViewModel] = []
                
                switch strongSelf.results {
                case .locations(let existingResults):
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                case .characters, .episodes:
                    break
                }
                
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    onComplete(newResults)
                }
            case .failure(let error):
                print(String(describing: error))
                strongSelf.isLoadingMoreResults = false
            }
        }
    }
    
    public func fetchAdditionalResults(onComplete: @escaping ([any Hashable]) -> Void) {
        if isLoadingMoreResults { return }
        
        guard let nextUrlString = next,
              let url = URL(string: nextUrlString),
              let request = RMRequest(url: url) else { return }
        
        isLoadingMoreResults = true
        
        switch results {
        case .characters(let currentResults):
            RMService.instance.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info

                    strongSelf.next = info.next
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterCollectionViewCellViewModel(characterName: $0.name,
                                                                      characterStatus: $0.status,
                                                                      characterImageUrl: URL(string: $0.image))
                    })
                    
                    var newResults: [RMCharacterCollectionViewCellViewModel] = []
                    newResults = currentResults + additionalResults
                    strongSelf.results = .characters(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        onComplete(newResults)
                    }
                case .failure(let error):
                    print(String(describing: error))
                    strongSelf.isLoadingMoreResults = false
                }
            }
        case .episodes(let currentResults):
            RMService.instance.execute(request, expecting: RMGetAllEpisodesResponse.self) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(let responseModel):
                    let moreResults = responseModel.results
                    let info = responseModel.info
                    
                    strongSelf.next = info.next
                    let additionalResults = moreResults.compactMap({
                        return RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
                    })
                    
                    var newResults: [RMCharacterEpisodeCollectionViewCellViewModel] = []
                    newResults = currentResults + additionalResults
                    strongSelf.results = .episodes(newResults)
                    
                    DispatchQueue.main.async {
                        strongSelf.isLoadingMoreResults = false
                        onComplete(newResults)
                    }
                case .failure(let error):
                    print(String(describing: error))
                    strongSelf.isLoadingMoreResults = false
                }
            }
        case .locations:
            break
        }
        
        
    }
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}
