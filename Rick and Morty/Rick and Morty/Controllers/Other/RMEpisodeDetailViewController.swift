//
//  RMEpisodeDetailViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 8.06.2023.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    private let url: URL?
    
    // MARK: - Init
    
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupperted")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .systemGreen
    }
}
