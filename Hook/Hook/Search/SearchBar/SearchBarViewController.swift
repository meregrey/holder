//
//  SearchBarViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import RIBs
import UIKit

protocol SearchBarPresentableListener: AnyObject {
    func didSearch(searchTerm: String)
    func cancelButtonDidTap()
}

final class SearchBarViewController: UIViewController, SearchBarPresentable, SearchBarViewControllable {
    
    static var searchBarTop: CGFloat { Metric.searchBarTop }
    static var searchBarBottom: CGFloat { -(Metric.searchBarBottom) }
    
    @AutoLayout private var searchBar = SearchBar(placeholder: LocalizedString.Placeholder.searchTitlesURLsNotes)
    
    private enum Metric {
        static let searchBarTop = Size.safeAreaTopInset + CGFloat(10)
        static let searchBarLeading = CGFloat(20)
        static let searchBarTrailing = CGFloat(-20)
        static let searchBarBottom = CGFloat(-12)
    }
    
    weak var listener: SearchBarPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let text = searchBar.text, text.count == 0 { searchBar.showCancelButton(false) }
    }
    
    func update(with searchTerm: String) {
        searchBar.becomeFirstResponder()
        searchBar.setSearchTerm(searchTerm)
        searchBar.resignFirstResponder()
    }
    
    private func configureViews() {
        searchBar.listener = self
        searchBar.addTargetToCancelButton(self, action: #selector(cancelButtonDidTap))
        
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Metric.searchBarTop),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.searchBarLeading),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.searchBarTrailing),
            searchBar.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.searchBarBottom)
        ])
    }
    
    @objc
    private func cancelButtonDidTap() {
        searchBar.endSearch()
        listener?.cancelButtonDidTap()
    }
}

extension SearchBarViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 0 else { return false }
        searchBar.resignFirstResponder()
        listener?.didSearch(searchTerm: text)
        return true
    }
}
