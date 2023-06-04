//
//  RMCharacterDetailViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 2.06.2023.
//

import UIKit

final class RMCharacterDetailViewController: UIViewController {
    private let viewModel: RMCharacterDetailViewViewModel
    private let detailView: RMCharacterDetailView

    // MARK: Init
    
    init(viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        self.detailView = RMCharacterDetailView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
        self.navigationItem.largeTitleDisplayMode = .never
        view.addSubview(detailView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShareButton))
        addConstraints()
        
        detailView.collectionView?.delegate = self
        detailView.collectionView?.dataSource = self
    }
    
    @objc private func didTapShareButton() {
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
        ])
    }
}

// MARK: CollectionView

extension RMCharacterDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RMCharacterDetailView.identifier, for: indexPath)
        cell.backgroundColor = .systemPink
        return cell
    }
}
