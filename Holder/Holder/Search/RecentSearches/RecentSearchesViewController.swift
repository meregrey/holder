//
//  RecentSearchesViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import RIBs
import UIKit

protocol RecentSearchesPresentableListener: AnyObject {
    func searchTermDidSelect(searchTerm: String)
    func clearButtonDidTap()
}

final class RecentSearchesViewController: UIViewController, RecentSearchesPresentable, RecentSearchesViewControllable {
    
    private let searchTermsMaximumCount = 10
    
    private var searchTerms: [String] = []
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    @AutoLayout private var recentSearchesLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.LabelText.recentSearches
        label.font = Font.recentSearchesLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var clearButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizedString.ActionTitle.clear, for: .normal)
        button.setTitleColor(Asset.Color.primaryColor, for: .normal)
        button.titleLabel?.font = Font.clearButton
        button.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @AutoLayout private var recentSearchesTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(RecentSearchesTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.backgroundColor = Asset.Color.baseBackgroundColor
        return tableView
    }()
    
    @AutoLayout private var noRecentSearchesView = ExplanationView(title: LocalizedString.LabelText.noRecentSearches,
                                                                   explanation: LocalizedString.LabelText.noRecentSearchesExplanation)
    
    private enum Font {
        static let recentSearchesLabel = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let clearButton = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    private enum Metric {
        static let stackViewTop = Size.searchBarViewHeight + 28
        static let stackViewLeading = CGFloat(20)
        static let stackViewTrailing = CGFloat(-20)
        
        static let recentSearchesTableViewTop = CGFloat(8)
    }
    
    weak var listener: RecentSearchesPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        registerToReceiveNotification()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerToReceiveNotification()
        configureViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func update(with searchTerms: [String]) {
        if searchTerms.count > 0 {
            self.searchTerms = Array(searchTerms.prefix(searchTermsMaximumCount))
            recentSearchesTableView.reloadData()
            noRecentSearchesView.isHidden = true
        } else {
            noRecentSearchesView.isHidden = false
        }
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow),
                                       name: UIResponder.keyboardWillShowNotification)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification)
    }
    
    @objc
    private func keyboardWillShow() {
        recentSearchesTableView.isScrollEnabled = true
    }
    
    @objc
    private func keyboardWillHide() {
        recentSearchesTableView.isScrollEnabled = false
    }
    
    private func configureViews() {
        recentSearchesTableView.dataSource = self
        recentSearchesTableView.delegate = self
        
        view.addSubview(stackView)
        view.addSubview(recentSearchesTableView)
        view.addSubview(noRecentSearchesView)
        stackView.addArrangedSubview(recentSearchesLabel)
        stackView.addArrangedSubview(clearButton)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.stackViewTrailing),
            
            recentSearchesTableView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: Metric.recentSearchesTableViewTop),
            recentSearchesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            recentSearchesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            recentSearchesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            noRecentSearchesView.topAnchor.constraint(equalTo: view.topAnchor),
            noRecentSearchesView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            noRecentSearchesView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            noRecentSearchesView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func clearButtonDidTap() {
        listener?.clearButtonDidTap()
    }
}

extension RecentSearchesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RecentSearchesTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: searchTerms[indexPath.row])
        return cell
    }
}

extension RecentSearchesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        listener?.searchTermDidSelect(searchTerm: searchTerms[indexPath.row])
    }
}
