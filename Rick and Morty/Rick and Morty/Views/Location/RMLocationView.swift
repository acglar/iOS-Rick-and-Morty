//
//  RMLocationView.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 12.06.2023.
//

import UIKit

protocol RMLocationViewDelegate: AnyObject {
    func rmLocationView(_ locationView: RMLocationView, didSelect location: RMLocation)
}

final class RMLocationView: UIView {
    public weak var delegate: RMLocationViewDelegate?
    
    private var viewModel: RMLocationViewViewModel? {
        didSet {
            spinner.stopAnimating()
            tableView.reloadData()
            tableView.isHidden = false
            UIView.animate(withDuration: 0.4) {
                self.tableView.alpha = 1
            }
            
            viewModel?.registerDidFinishPagination { [weak self] in
                DispatchQueue.main.async {
                    self?.tableView.tableFooterView = nil
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.alpha = 0
        table.isHidden = true
        table.register(RMLocationTableViewCell.self, forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        return table
    }()
    
    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(tableView, spinner)
        spinner.startAnimating()
        addConstraints()
        configureTable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
        ])
    }
    
    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    public func configure(with viewModel: RMLocationViewViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Tableview Delegate

extension RMLocationView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let location = viewModel?.location(at: indexPath.row) {
            delegate?.rmLocationView(self, didSelect: location)
        }
    }
}

// MARK: - Tableview Datasource

extension RMLocationView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cellViewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModels = viewModel?.cellViewModels else { fatalError() }
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RMLocationTableViewCell.cellIdentifier, for: indexPath
        ) as? RMLocationTableViewCell else { fatalError() }
        
        let cellViewModel = cellViewModels[indexPath.row]
        cell.configure(with: cellViewModel)
        
        return cell
    }
}

// MARK: - Scrollview Delegate

extension RMLocationView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !viewModel.cellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreLocations else { return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showLoadingIndicator()
                }
                
                viewModel.fetchAdditionalLocations()
            }
            
            timer.invalidate()
        }
    }
    
    private func showLoadingIndicator() {
        let frame = CGRect(x: 0, y: 0, width: frame.size.width, height: 100)
        let footer = RMTableLoadingFooterView(frame: frame)
        tableView.tableFooterView = footer
    }
}
