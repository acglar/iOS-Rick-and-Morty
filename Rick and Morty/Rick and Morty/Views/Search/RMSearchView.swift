//
//  RMSearchView.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 13.06.2023.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
    func rmSearchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter)
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode)
}

final class RMSearchView: UIView {
    public weak var delegate: RMSearchViewDelegate?
    private let viewModel: RMSearchViewViewModel
    
    // MARK: - Subviews
    
    private let searchInputView = RMSearchInputView()
    private let noResultsView = RMNoSearchResultsView()
    private let resultsView = RMSearchResultsView()
    
    // MARK: - Init
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(resultsView, noResultsView, searchInputView)
        addConstraints()
        setUpHandlers(viewModel: viewModel)
        
        searchInputView.configure(with: .init(type: viewModel.config.type))
        searchInputView.delegate = self
        resultsView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    
    private func setUpHandlers(viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self?.resultsView.configure(with: result)
                self?.noResultsView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registerNoSearchResultHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultsView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            // No results view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            // results view
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            
            // No results view
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    // MARK: - Public
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

// MARK: - CollectionView

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

// MARK: - RMSearchInputView Delegate

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchButtonOnKeyboard(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}

// MARK: - RMSearchResultsView Delegate

extension RMSearchView: RMSearchResultsViewDelegate {
    // Location
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else { return }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
    
    // Character
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int) {
        guard let characterModel = viewModel.characterSearchResult(at: index) else { return }
        delegate?.rmSearchView(self, didSelectCharacter: characterModel)
    }

    // Episode
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int) {
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else { return }
        delegate?.rmSearchView(self, didSelectEpisode: episodeModel)
    }
}
