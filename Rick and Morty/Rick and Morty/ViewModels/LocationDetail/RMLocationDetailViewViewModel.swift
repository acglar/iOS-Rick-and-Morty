//
//  RMLocationDetailViewViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 13.06.2023.
//

import UIKit

protocol RMLocationDetailViewViewModelDelegate: AnyObject {
    func didFetchLocationDetails()
}

final class RMLocationDetailViewViewModel {
    private let endPointUrl: URL?
    private var dataTuple: (location: RMLocation, characters: [RMCharacter])? {
        didSet {
            createCellViewModels()
            delegate?.didFetchLocationDetails()
        }
    }
    
    enum SectionType {
        case information(viewModels: [RMEpisodeInfoCollectionViewCellViewModel])
        case characters(viewModels: [RMCharacterCollectionViewCellViewModel])
    }
    
    public weak var delegate: RMLocationDetailViewViewModelDelegate?
    public private(set) var cellViewModels: [SectionType] = []
    
    // MARK: - Init
    
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
    }
    
    // MARK: - Public
    
    public func fetchLocationData() {
        guard let url = endPointUrl, let request = RMRequest(url: url) else { return }
        
        RMService.instance.execute(request, expecting: RMLocation.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.fetchRelatedCharacters(location: model)
                
            case .failure:
                break
            }
        }
    }
    
    public func character(at index: Int) -> RMCharacter? {
        guard let dataTuple = dataTuple else { return nil }
        return dataTuple.characters[index]
    }
    
    // MARK: - Private
    
    private func createCellViewModels() {
        guard let dataTuple = dataTuple else { return }
        
        let location = dataTuple.location
        let characters = dataTuple.characters
        
        var createdStringForDate = ""
        if let date = RMCharacterInfoCollectionViewCellViewModel.dateFormatter.date(from: location.created) {
            createdStringForDate = RMCharacterInfoCollectionViewCellViewModel.shortDateFormatter.string(from: date)
        }
        
        cellViewModels = [
            .information(viewModels: [
                .init(title: "Location Name", value: location.name),
                .init(title: "Type", value: location.type),
                .init(title: "Dimension", value: location.dimension),
                .init(title: "Created", value: createdStringForDate),
            ]),
            .characters(viewModels: characters.compactMap({ character in
                return RMCharacterCollectionViewCellViewModel(characterName: character.name,
                                                              characterStatus: character.status,
                                                              characterImageUrl: URL(string: character.image))
            }))
        ]
    }
    
    private func fetchRelatedCharacters(location: RMLocation) {
        let characterUrls: [URL] = location.residents.compactMap({
            return URL(string: $0)
        })
        
        let requests: [RMRequest] = characterUrls.compactMap({
            return RMRequest(url: $0)
        })
        
        let group = DispatchGroup()
        var characters: [RMCharacter] = []
        
        for request in requests {
            group.enter()
            RMService.instance.execute(request, expecting: RMCharacter.self) { result in
                defer {
                    group.leave()
                }
                
                switch result {
                case .success(let model):
                    characters.append(model)
                case .failure:
                    break
                }
            }
        }
        
        group.notify(queue: .main) {
            self.dataTuple = (
                location: location,
                characters: characters
            )
        }
    }
}
