//
//  RMSearchView.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 13.06.2023.
//

import UIKit

final class RMSearchView: UIView {
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    
    private let searchInputView = RMSearchInputView()
    private let noResultsView = RMNoSearchResultsView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: .init(type: viewModel.config.type))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // No results view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: 110),
            
            // No results view
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

// MARK: - CollectenView

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
