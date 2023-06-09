//
//  RMSearchViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 9.06.2023.
//

import UIKit

final class RMSearchViewController: UIViewController {
    
    struct Config {
        enum `Type`{
            case character
            case episode
            case location
        }
        
        let type: `Type`
    }
    
    private let config: Config
    
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
    }
}
