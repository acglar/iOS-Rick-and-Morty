//
//  RMSearchResultsView.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 16.06.2023.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapCharacterAt index: Int)
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapEpisodeAt index: Int)
}

final class RMSearchResultsView: UIView {
    public weak var delegate: RMSearchResultsViewDelegate?
    
    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    private var collectionViewCellViewModels: [any Hashable] = []
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.isHidden = true
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        return table
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, collectionView)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Private
    
    private func processViewModel() {
        guard let viewModel = viewModel else { return }
        
        switch viewModel.results {
        case .characters(let viewModels):
            setUpCollectionView(viewModels: viewModels)
        case .episodes(let viewModels):
            setUpCollectionView(viewModels: viewModels)
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
        }
    }
    
    private func setUpTableView(viewModels: [RMLocationTableViewCellViewModel]) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }
    
    private func setUpCollectionView(viewModels: [any Hashable]) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isHidden = false
        tableView.isHidden = true
        self.collectionViewCellViewModels = viewModels
        collectionView.reloadData()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - TableView Delegate

extension RMSearchResultsView: UITableViewDelegate {
    
}


// MARK: - TableView DataSource

extension RMSearchResultsView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RMLocationTableViewCell.cellIdentifier,
                                                       for: indexPath) as? RMLocationTableViewCell else {
            fatalError()
        }
        
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

// MARK: - CollectionView

extension RMSearchResultsView: UICollectionViewDelegate {
    
}

extension RMSearchResultsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else { return }
        
        switch viewModel.results {
        case .characters:
            delegate?.rmSearchResultsView(self, didTapCharacterAt: indexPath.row)
        case .episodes:
            delegate?.rmSearchResultsView(self, didTapEpisodeAt: indexPath.row)
        case .locations:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let objectAtIndex = collectionViewCellViewModels[indexPath.row]
        
        // Character
        if objectAtIndex is RMCharacterCollectionViewCellViewModel {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterCollectionViewCell else { fatalError() }
            
            if let characterViewModel = objectAtIndex as? RMCharacterCollectionViewCellViewModel {
                cell.configure(with: characterViewModel)
            }
            
            return cell
        }
        
        // Episode
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.identifier,
            for: indexPath) as? RMCharacterEpisodeCollectionViewCell else { fatalError() }
        
        if let episodeViewModel = objectAtIndex as? RMCharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeViewModel)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter,
              let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
                for: indexPath) as? RMFooterLoadingCollectionReusableView else { fatalError("Unsupported") }
        
        if let viewModel = viewModel, viewModel.shouldShowLoadMoreIndicator {
            footer.startAnimating()
        }
        
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let viewModel = viewModel,
              viewModel.shouldShowLoadMoreIndicator else {
            return .zero
        }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

// MARK: - CollectionView FlowLayout

extension RMSearchResultsView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let objectAtIndex = collectionViewCellViewModels[indexPath.row]
        
        let bounds = collectionView.bounds
        
        // Character
        if objectAtIndex is RMCharacterCollectionViewCellViewModel {
            let width = UIDevice.isIphone ? (bounds.width - 30) / 2 : (bounds.width - 50) / 4
            
            return CGSize(width: width, height: width * 1.5)
        }
        
        // Episode
        let width = UIDevice.isIphone ? (bounds.width - 20) : (bounds.width - 50) / 4
        
        return CGSize(width: width, height: 100)
    }
}

// MARK: - Scrollview Delegate

extension RMSearchResultsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !locationCellViewModels.isEmpty {
            handleLocationPagination(scrollView: scrollView)
        } else {
            handleCharacterOrEpisodePagination(scrollView: scrollView)
        }
    }
    
    private func handleCharacterOrEpisodePagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !collectionViewCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                viewModel.fetchAdditionalResults { [weak self] newResults in
                    guard let strongSelf = self else { return }
                    
                    DispatchQueue.main.async {
                        strongSelf.tableView.tableFooterView = nil
                        
                        let originalCount = strongSelf.collectionViewCellViewModels.count
                        let newCount = (newResults.count - originalCount)
                        let total = originalCount + newCount
                        let startingIndex = total - newCount
                        let indexPathsToAdd: [IndexPath] = Array(startingIndex..<(startingIndex + newCount)).compactMap({
                            return IndexPath(row: $0, section: 0)
                        })
                        
                        strongSelf.collectionView.insertItems(at: indexPathsToAdd)
                        strongSelf.collectionViewCellViewModels = newResults
                    }
                }
            }
            
            timer.invalidate()
        }
    }
    
    private func handleLocationPagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !locationCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showTableLoadingIndicator()
                }
                
                viewModel.fetchAdditionalLocations { [weak self] newResults in
                    self?.tableView.tableFooterView = nil
                    self?.locationCellViewModels = newResults
                    self?.tableView.reloadData()
                }
            }
            
            timer.invalidate()
        }
    }
    
    private func showTableLoadingIndicator() {
        let frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 100)
        let footer = RMTableLoadingFooterView(frame: frame)
        tableView.tableFooterView = footer
    }
}
