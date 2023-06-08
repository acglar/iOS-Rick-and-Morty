//
//  RMEpisodeDetailViewViewModel.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 8.06.2023.
//

import UIKit

final class RMEpisodeDetailViewViewModel {
    private let endPointUrl: URL?
    
    init(endPointUrl: URL?) {
        self.endPointUrl = endPointUrl
        fetchEpisodeData()
    }
    
    private func fetchEpisodeData() {
        guard let url = endPointUrl, let request = RMRequest(url: url) else { return }
        
        RMService.instance.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let success):
                break
            case .failure(let failure):
                break
            }
        }
    }
}
