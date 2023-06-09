//
//  RMCharacterViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 22.05.2023.
//

import UIKit

final class RMCharacterViewController: UIViewController {
    
    private let characterListView = RMCharacterListView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Characters"
        view.backgroundColor = .systemBackground
        setUpView()
        addSearchBar()
    }
    
    private func setUpView() {
        characterListView.delegate = self
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
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

extension RMCharacterViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        let viewModel = RMCharacterDetailViewViewModel(character: character)
        let detailViewController = RMCharacterDetailViewController(viewModel: viewModel)
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
