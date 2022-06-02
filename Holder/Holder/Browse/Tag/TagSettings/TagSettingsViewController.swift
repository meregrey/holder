//
//  TagSettingsViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import CoreData
import RIBs
import UIKit

protocol TagSettingsPresentableListener: AnyObject {
    func backButtonDidTap()
    func addTagButtonDidTap()
    func editTagsButtonDidTap()
    func tagDidSelect(tag: Tag)
    func didRemove()
}

final class TagSettingsViewController: UIViewController, TagSettingsPresentable, TagSettingsViewControllable {
    
    weak var listener: TagSettingsPresentableListener?
    
    private var fetchedResultsController: NSFetchedResultsController<TagEntity>?
    
    @AutoLayout private var tagSettingsTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TagSettingsTableViewCell.self)
        tableView.tableHeaderView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Asset.Color.baseBackgroundColor
        return tableView
    }()
    
    private enum Image {
        static let backButton = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        static let addTagButton = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        static let editTagsButton = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let tagSettingsTableViewRowHeight = CGFloat(80)
    }
    
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
        configureNavigationBar(backgroundColor: Asset.Color.baseBackgroundColor)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    func update(with fetchedResultsController: NSFetchedResultsController<TagEntity>) {
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController?.delegate = self
        DispatchQueue.main.async {
            self.tagSettingsTableView.reloadData()
        }
    }
    
    func scrollToBottom() {
        let numberOfRows = tagSettingsTableView.numberOfRows(inSection: 0)
        guard numberOfRows > 0 else { return }
        let indexPath = IndexPath(row: numberOfRows - 1, section: 0)
        DispatchQueue.main.async {
            self.tagSettingsTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    private func configureViews() {
        tagSettingsTableView.dataSource = self
        tagSettingsTableView.delegate = self
        
        title = LocalizedString.ViewTitle.tagSettings
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.backButton, style: .done, target: self, action: #selector(backButtonDidTap))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: Image.editTagsButton, style: .plain, target: self, action: #selector(editTagsButtonDidTap)),
                                              UIBarButtonItem(image: Image.addTagButton, style: .plain, target: self, action: #selector(addTagButtonDidTap))]
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        view.addSubview(tagSettingsTableView)
        
        NSLayoutConstraint.activate([
            tagSettingsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            tagSettingsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagSettingsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tagSettingsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.backButtonDidTap()
    }
    
    @objc
    private func addTagButtonDidTap() {
        listener?.addTagButtonDidTap()
    }
    
    @objc
    private func editTagsButtonDidTap() {
        listener?.editTagsButtonDidTap()
    }
}

// MARK: - Data Source

extension TagSettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TagSettingsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        guard let tagEntity = fetchedResultsController?.fetchedObjects?[indexPath.row] else { return cell }
        cell.configure(with: Tag(name: tagEntity.name))
        return cell
    }
}

// MARK: - Delegate

extension TagSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.tagSettingsTableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let tagEntity = fetchedResultsController?.fetchedObjects?[indexPath.row] else { return }
        listener?.tagDidSelect(tag: Tag(name: tagEntity.name))
    }
}

// MARK: - Fetched Results Controller Delegate

extension TagSettingsViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tagSettingsTableView.reloadData()
    }
}
