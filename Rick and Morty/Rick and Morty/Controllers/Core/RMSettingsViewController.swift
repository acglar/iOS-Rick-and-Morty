//
//  RMSettingsViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 22.05.2023.
//

import UIKit

final class RMSettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Settings"
        view.backgroundColor = .systemBackground
        addSearchBar()
    }
    
    private func addSearchBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearchBar))
    }
    
    @objc
    private func didTapSearchBar() {
        let viewController = RMSearchViewController(config: .init(type: .character))
        navigationController?.pushViewController(viewController, animated: true)
    }
}
