//
//  SelectTagsViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/04.
//

import CoreData
import RIBs
import UIKit

protocol SelectTagsPresentableListener: AnyObject {
    func cancelButtonDidTap()
    func searchBarDidTap()
    func doneButtonDidTap(selectedTags: [Tag])
}

final class SelectTagsViewController: UIViewController, SelectTagsPresentable, SelectTagsViewControllable {
    
    private var selectedTags: [Tag] = []
    private var fetchedResultsController: NSFetchedResultsController<TagEntity>?
    
    @AutoLayout private var topView: UIView
    
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
        
        static let doneButtonLeading = CGFloat(20)
        static let doneButtonTrailing = CGFloat(-20)
        static let doneButtonBottom = CGFloat(-40)
    }
    
    weak var listener: SelectTagsPresentableListener?
    
    init(topBarStyle: TopBarStyle) {
        let title = LocalizedString.ViewTitle.selectTags
        topView = topBarStyle == .sheetHeader ? SheetHeaderView(title: title) : SingleButtonNavigationBar(title: title)
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        topView = UIView()
        super.init(coder: coder)
        configureViews()
    }
    
    func update(with fetchedResultsController: NSFetchedResultsController<TagEntity>, existingSelectedTags: [Tag]) {
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController?.delegate = self
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
        guard let tagEntities = fetchedResultsController?.fetchedObjects else { return }
        guard let tagEntity = tagEntities.filter({ $0.name == tagBySearch.name }).first else { return }
        let indexPath = IndexPath(row: Int(tagEntity.index), section: 0)
        DispatchQueue.main.async {
            self.selectTagsTableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            self.selectTagsTableView.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private func configureViews() {
        if let sheetHeaderView = topView as? SheetHeaderView {
            sheetHeaderView.listener = self
        }
        
        if let navigationBar = topView as? SingleButtonNavigationBar {
            navigationBar.listener = self
        }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchBarDidTap))
        searchBar.addGestureRecognizer(tapGestureRecognizer)
        
        selectTagsTableView.dataSource = self
        selectTagsTableView.delegate = self
        
        view.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        view.addSubview(topView)
        view.addSubview(searchBar)
        view.addSubview(selectTagsTableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchBar.topAnchor.constraint(equalTo: topView.bottomAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            selectTagsTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: Metric.selectTagsTableViewTop),
            selectTagsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectTagsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectTagsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.doneButtonLeading),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.doneButtonTrailing),
            doneButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.doneButtonBottom)
        ])
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

// MARK: - Top View Listener

extension SelectTagsViewController: SheetHeaderViewListener, SingleButtonNavigationBarListener {
    
    func cancelButtonDidTap() {
        listener?.cancelButtonDidTap()
    }
}

// MARK: - Data Source

extension SelectTagsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return fetchedResultsController?.fetchedObjects?.count ?? 0 }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: SelectTagsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            guard let tagEntities = fetchedResultsController?.fetchedObjects else { return cell }
            let tag = Tag(name: tagEntities[indexPath.row].name)
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

// MARK: - Delegate

extension SelectTagsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.selectTagsTableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? SelectTagsTableViewCell else { return }
        guard let tagEntities = fetchedResultsController?.fetchedObjects else { return }
        let tag = Tag(name: tagEntities[indexPath.row].name)
        
        if selectedTags.contains(tag) {
            let index = selectedTags.firstIndex(of: tag) ?? 0
            selectedTags.remove(at: index)
        } else {
            selectedTags.append(tag)
        }
        
        cell.isChecked.toggle()
    }
}

// MARK: - Fetched Results Controller Delegate

extension SelectTagsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        selectTagsTableView.reloadData()
    }
}
