//
//  SearchTagsViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/12.
//

import RIBs
import UIKit

protocol SearchTagsPresentableListener: AnyObject {
    func cancelButtonDidTap()
    func rowDidSelect(tag: Tag, shouldAddTag: Bool)
}

final class SearchTagsViewController: UIViewController, SearchTagsPresentable, SearchTagsViewControllable {
    
    private var tags: [Tag] = []
    private var texts: [String] = []
    private var shouldAddTag = false
    
    @AutoLayout private var searchBar = SearchBar(placeholder: LocalizedString.Placeholder.searchAndAdd,
                                                  showsCancelButton: true,
                                                  theme: .sheet)
    
    @AutoLayout private var searchTagsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchTagsTableViewCell.self)
        tableView.tableHeaderView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        return tableView
    }()
    
    private var searchTagsTableViewHeightConstraint: NSLayoutConstraint?
    
    private enum Metric {
        static let searchBarTop = CGFloat(20)
        static let searchBarLeading = CGFloat(20)
        static let searchBarTrailing = CGFloat(-20)
        
        static let searchTagsTableViewRowHeight = CGFloat(80)
        static let searchTagsTableViewLastRowHeight = CGFloat(15)
        static let searchTagsTableViewTop = CGFloat(20)
    }
    
    weak var listener: SearchTagsPresentableListener?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.becomeFirstResponder()
    }
    
    func update(with tags: [Tag]) {
        self.tags = tags
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(textDidChange(_:)),
                                       name: UITextField.textDidChangeNotification)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: UIResponder.keyboardWillShowNotification)
    }
    
    @objc
    private func textDidChange(_ notification: Notification) {
        guard let textField = notification.object as? UITextField else { return }
        guard let input = textField.text else { return }
        reloadSearchTagsTableView(with: input)
    }
    
    private func reloadSearchTagsTableView(with input: String) {
        texts = input.count > 0 ? texts(for: input) : []
        searchTagsTableView.reloadData()
    }
    
    private func texts(for input: String) -> [String] {
        let filteredTags = tags.filter { $0.name.lowercased().contains(input) }
        if filteredTags.count > 0 {
            shouldAddTag = false
            return filteredTags.map { $0.name }
        } else {
            shouldAddTag = true
            let localization = Bundle.main.preferredLocalizations.first ?? ""
            let text = localization == "ko" ? "'\(input)' 태그 추가" : "Add Tag '\(input)'"
            return [text]
        }
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let heightForTop = Metric.searchBarTop + searchBar.frame.height + Metric.searchTagsTableViewTop
        let searchTagsTableViewHeight = view.frame.height - keyboardFrame.height - heightForTop
        searchTagsTableViewHeightConstraint?.constant = searchTagsTableViewHeight
        view.layoutIfNeeded()
    }
    
    private func configureViews() {
        searchBar.addTargetToCancelButton(self, action: #selector(cancelButtonDidTap))
        
        searchTagsTableView.dataSource = self
        searchTagsTableView.delegate = self
        searchTagsTableViewHeightConstraint = NSLayoutConstraint(item: searchTagsTableView,
                                                                 attribute: .height,
                                                                 relatedBy: .equal,
                                                                 toItem: nil,
                                                                 attribute: .notAnAttribute,
                                                                 multiplier: 1,
                                                                 constant: view.frame.height)
        searchTagsTableView.addConstraint(searchTagsTableViewHeightConstraint ?? NSLayoutConstraint())
        
        view.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        view.addSubview(searchBar)
        view.addSubview(searchTagsTableView)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.topAnchor, constant: Metric.searchBarTop),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.searchBarLeading),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.searchBarTrailing),
            
            searchTagsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Metric.searchTagsTableViewTop),
            searchTagsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchTagsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc
    private func cancelButtonDidTap() {
        listener?.cancelButtonDidTap()
    }
}

extension SearchTagsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return texts.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SearchTagsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: texts[indexPath.row])
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
    }
}

extension SearchTagsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return Metric.searchTagsTableViewRowHeight }
        return Metric.searchTagsTableViewLastRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SearchTagsTableViewCell else { return }
        var text = cell.text
        if shouldAddTag {
            guard let firstIndex = text.firstIndex(of: "'") else { return }
            guard let lastIndex = text.lastIndex(of: "'") else { return }
            let range = text.index(after: firstIndex)..<lastIndex
            text = String(text[range])
        }
        listener?.rowDidSelect(tag: Tag(name: text), shouldAddTag: shouldAddTag)
    }
}
