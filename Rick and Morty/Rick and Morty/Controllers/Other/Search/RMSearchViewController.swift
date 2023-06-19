//
//  RMSearchViewController.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 9.06.2023.
//

import UIKit

final class RMSearchViewController: UIViewController {
    
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
            
            var endpoint: RMEndpoint {
                switch self {
                case .character:
                    return .character
                case .episode:
                    return .episode
                case .location:
                    return .location
                }
            }
            
            var title: String {
                switch self {
                case .character:
                    return "Search Character"
                case .episode:
                    return "Search Episode"
                case .location:
                    return "Search Location"
                }
            }
        }
        
        let type: `Type`
    }
    
    private let viewModel: RMSearchViewViewModel
    private let searchView: RMSearchView
    
    // MARK: - Init
    
    init(config: Config) {
        self.viewModel = .init(config: config)
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .systemBackground
        view.addSubview(searchView)
        addConstraints()
        searchView.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapExecuteSearch))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }
    
    @objc
    private func didTapExecuteSearch() {
        viewModel.executeSearch()
    }
    
    // MARK: - Private
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - SearchView Delegate

extension RMSearchViewController: RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter) {
        let viewController = RMCharacterDetailViewController(viewModel: .init(character: character))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode) {
        let viewController = RMEpisodeDetailViewController(url: URL(string: episode.url))
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) {
        let viewController = RMLocationDetailViewController(location: location)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption) {
        let viewController = RMSearchOptionPickerViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        viewController.sheetPresentationController?.detents = [.medium()]
        viewController.sheetPresentationController?.prefersGrabberVisible = true
        present(viewController, animated: true)
    }
}
