//
//  SelectTagsViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/04.
//

import RIBs
import UIKit

protocol SelectTagsPresentableListener: AnyObject {
    func closeButtonDidTap()
    func searchBarDidTap()
    func doneButtonDidTap(selectedTags: [Tag])
}

final class SelectTagsViewController: UIViewController, SelectTagsPresentable, SelectTagsViewControllable {
    
    private var tags: [Tag] = []
    private var selectedTags: [Tag] = []
    
    @AutoLayout private var headerView = SheetHeaderView(title: LocalizedString.ViewTitle.selectTags)
    
    @AutoLayout private var searchBar = SearchBar(placeholder: LocalizedString.Placeholder.searchAndAdd,
                                                  isInputEnabled: false,
                                                  theme: .sheet)
    
    @AutoLayout private var selectTagsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SelectTagsTableViewCell.self)
        tableView.tableHeaderView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        return tableView
    }()
    
    @AutoLayout private var doneButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ActionTitle.done, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.backgroundColor = Asset.Color.primaryColor
        button.addTarget(self, action: #selector(doneButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private enum Metric {
        static let selectTagsTableViewCellHeight = CGFloat(80)
        static let selectTagsTableViewTop = CGFloat(20)
        
        static let doneButtonHeight = RoundedCornerButton.height
        static let doneButtonLeading = CGFloat(20)
        static let doneButtonTrailing = CGFloat(-20)
        static let doneButtonBottom = CGFloat(-40)
    }
    
    weak var listener: SelectTagsPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func update(with tags: [Tag], existingSelectedTags: [Tag]) {
        let filteredTags = tags.filter { $0.name != TagName.all }
        self.tags = filteredTags
        self.selectedTags = existingSelectedTags
        DispatchQueue.main.async {
            self.selectTagsTableView.reloadData()
        }
    }
    
    func update(with tagBySearch: Tag) {
        if selectedTags.contains(tagBySearch) {
            DispatchQueue.main.async {
                self.presentAlert(title: LocalizedString.AlertTitle.tagAlreadySelected, message: LocalizedString.AlertMessage.tagAlreadySelected)
            }
            return
        }
        selectedTags.append(tagBySearch)
        guard let row = tags.firstIndex(of: tagBySearch) else { return }
        let indexPath = IndexPath(row: row, section: 0)
        DispatchQueue.main.async {
            self.selectTagsTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            self.selectTagsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func configureViews() {
        headerView.addTargetToCloseButton(self, action: #selector(closeButtonDidTap))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchBarDidTap))
        searchBar.addGestureRecognizer(tapGestureRecognizer)
        
        selectTagsTableView.dataSource = self
        selectTagsTableView.delegate = self
        
        view.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        view.addSubview(headerView)
        view.addSubview(searchBar)
        view.addSubview(selectTagsTableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            selectTagsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Metric.selectTagsTableViewTop),
            selectTagsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectTagsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectTagsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            doneButton.heightAnchor.constraint(equalToConstant: Metric.doneButtonHeight),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.doneButtonLeading),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.doneButtonTrailing),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.doneButtonBottom)
        ])
    }
    
    @objc
    private func closeButtonDidTap() {
        listener?.closeButtonDidTap()
    }
    
    @objc
    private func searchBarDidTap() {
        listener?.searchBarDidTap()
    }
    
    @objc
    private func doneButtonDidTap() {
        listener?.doneButtonDidTap(selectedTags: selectedTags)
    }
}

extension SelectTagsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return tags.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SelectTagsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            let tag = tags[indexPath.row]
            let flag = selectedTags.contains(tag)
            cell.configure(with: tag, selected: flag)
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            return cell
        }
    }
}

extension SelectTagsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.selectTagsTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectTagsTableViewCell else { return }
        let tag = tags[indexPath.row]
        
        if selectedTags.contains(tag) {
            let index = selectedTags.firstIndex(of: tag) ?? 0
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
        
        cell.isChecked.toggle()
    }
}
