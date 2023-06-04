//
//  RMCharacterDetailView.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 2.06.2023.
//

import UIKit

final class RMCharacterDetailView: UIView {
    static let identifier = "characterDetailView"
    
    public var collectionView: UICollectionView?
    
    private let viewModel: RMCharacterDetailViewViewModel
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMCharacterDetailViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        let collectionView = createCollectionView()
        self.collectionView = collectionView
        addSubviews(collectionView, spinner)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            return self?.createSection(for: sectionIndex)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: RMCharacterDetailView.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }
    
    private func createSection(for sectionIndex: Int) -> NSCollectionLayoutSection {
        let sectionTypes = viewModel.sections
        
        switch sectionTypes[sectionIndex] {
        case .photo:
            return createPhotoSectionLayout()
        case .information:
            return createInfoSectionLayout()
        case .episodes:
            return createEpisodesSectionLayout()
        }
    }
    
    private func createPhotoSectionLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                             heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0)
        
        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .absolute(150)),
            subitems: [item])
        return NSCollectionLayoutSection(group: group)
    }
    
    private func createInfoSectionLayout() -> NSCollectionLayoutSection {
        createPhotoSectionLayout() // temp
    }
    
    private func createEpisodesSectionLayout() -> NSCollectionLayoutSection {
        createPhotoSectionLayout() // temp
    }
}
