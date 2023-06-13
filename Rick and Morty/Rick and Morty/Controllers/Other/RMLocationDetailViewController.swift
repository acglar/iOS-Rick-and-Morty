//
//  RMLocationDetailViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 13.06.2023.
//

import UIKit

final class RMLocationDetailViewController: UIViewController {
    private let viewModel: RMLocationDetailViewViewModel
    private let detailView = Rick_and_Morty.RMLocationDetailView()
    
    // MARK: - Init
    
    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewViewModel(endPointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupperted")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Location"
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(detailView)
        addConstraints()
        detailView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        
        viewModel.delegate = self
        viewModel.fetchLocationData()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
    
    @objc
    private func didTapShareButton() {
        
    }
}

// MARK: - Delegate

extension RMLocationDetailViewController: RMLocationDetailViewViewModelDelegate, RMLocationDetailViewDelegate {
    func RMLocationDetailView(_ detailView: RMLocationDetailView, didSelect character: RMCharacter) {
        let viewController = RMCharacterDetailViewController(viewModel: .init(character: character))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}
