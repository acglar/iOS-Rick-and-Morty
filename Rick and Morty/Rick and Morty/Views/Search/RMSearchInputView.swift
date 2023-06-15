//
//  RMSearchInputView.swift
//  Rick and Morty
//
//  Created by Ali ÇAĞLAR on 13.06.2023.
//

import UIKit

protocol RMSearchInputViewDelegate: AnyObject {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOption)
}

final class RMSearchInputView: UIView {
    public weak var delegate: RMSearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: RMSearchInputViewViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else { return }
            let options = viewModel.options
            createOptionSelectionViews(options: options)
        }
    }
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(searchBar)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    // MARK: - Private
    
    private func createOptionSelectionViews(options: [RMSearchInputViewViewModel.DynamicOption]) {
        let stackView = createOptionStackView()
        
        for i in 0..<options.count {
            let option = options[i]
            let button = createButtonFor(option, index: i)
            
            stackView.addArrangedSubview(button)
        }
    }
    
    private func createButtonFor(_ option: RMSearchInputViewViewModel.DynamicOption, index: Int) -> UIButton {
        let button = UIButton()
        
        button.setAttributedTitle(
            NSAttributedString(
                string: option.rawValue,
                attributes: [
                    .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                    .foregroundColor: UIColor.label
            ]),
            for: .normal
        )
        
        button.layer.cornerRadius = 6
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = index
        
        return button
    }
    
    private func createOptionStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 6
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: leftAnchor),
            stackView.rightAnchor.constraint(equalTo: rightAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        return stackView
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else { return }
        
        let tag = sender.tag
        let selected = options[tag]
        
        delegate?.rmSearchInputView(self, didSelectOption: selected)
    }
    
    // MARK: - Public
    
    public func configure(with viewModel: RMSearchInputViewViewModel) {
        searchBar.placeholder = viewModel.searchBarPlaceHolderText
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
}
