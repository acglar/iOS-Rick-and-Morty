//
//  RMEpisodeDetailViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 8.06.2023.
//

import UIKit

final class RMEpisodeDetailViewController: UIViewController {
    private let viewModel: RMEpisodeDetailViewViewModel
    private let detailView = Rick_and_Morty.RMEpisodeDetailView()
    
    // MARK: - Init
    
    init(url: URL?) {
        self.viewModel = .init(endPointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupperted")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        navigationItem.largeTitleDisplayMode = .never
        view.addSubview(detailView)
        addConstraints()
        detailView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        
        viewModel.delegate = self
        viewModel.fetchEpisodeData()
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

extension RMEpisodeDetailViewController: RMEpisodeDetailViewViewModelDelegate, RMEpisodeDetailViewDelegate {
    func RMEpisodeDetailView(_ detailView: RMEpisodeDetailView, didSelect character: RMCharacter) {
        let viewController = RMCharacterDetailViewController(viewModel: .init(character: character))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
}
