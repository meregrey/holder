//
//  EditTagsViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/15.
//

import RIBs
import UIKit

protocol EditTagsPresentableListener: AnyObject {
    func backButtonDidTap()
    func saveButtonDidTap(remainingTags: [Tag], deletedTags: [Tag])
    func didRemove()
}

final class EditTagsViewController: UIViewController, EditTagsPresentable, EditTagsViewControllable {
    
    private var tags: [Tag] = []
    private var deletedTags: [Tag] = []
    
    @AutoLayout private var editTagsTableView: EditTagsTableView = {
        let tableView = EditTagsTableView()
        tableView.register(EditTagsTableViewCell.self)
        tableView.isEditing = true
        tableView.separatorStyle = .none
        tableView.backgroundColor = Asset.Color.baseBackgroundColor
        return tableView
    }()
    
    @AutoLayout private var saveButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ActionTitle.save, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.backgroundColor = Asset.Color.primaryColor
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private enum Image {
        static let back = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let editTagsTableViewRowHeight = CGFloat(80)
        
        static let saveButtonHeight = RoundedCornerButton.height
        static let saveButtonLeading = CGFloat(20)
        static let saveButtonTrailing = CGFloat(-20)
        static let saveButtonBottom = CGFloat(-40)
    }
    
    weak var listener: EditTagsPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    func update(with tags: [Tag]) {
        self.tags = tags
    }
    
    private func configureViews() {
        editTagsTableView.dataSource = self
        editTagsTableView.delegate = self
        
        title = LocalizedString.ViewTitle.editTags
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.back, style: .done, target: self, action: #selector(backButtonDidTap))
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        view.addSubview(editTagsTableView)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            editTagsTableView.topAnchor.constraint(equalTo: view.topAnchor),
            editTagsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editTagsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editTagsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            saveButton.heightAnchor.constraint(equalToConstant: Metric.saveButtonHeight),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.saveButtonLeading),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.saveButtonTrailing),
            saveButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.saveButtonBottom)
        ])
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.backButtonDidTap()
    }
    
    @objc
    private func saveButtonDidTap() {
        listener?.saveButtonDidTap(remainingTags: tags, deletedTags: deletedTags)
    }
}

extension EditTagsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return tags.count }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell: EditTagsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.configure(with: tags[indexPath.row])
            return cell
        } else {
            let cell = UITableViewCell()
            cell.backgroundColor = .clear
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 { return true }
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let tag = tags.remove(at: sourceIndexPath.row)
        tags.insert(tag, at: destinationIndexPath.row)
    }
}

extension EditTagsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.editTagsTableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tags[indexPath.row].name == TagName.all { return .none }
        return .delete
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: LocalizedString.ActionTitle.delete) { _, _, _ in
            self.deletedTags.append(self.tags[indexPath.row])
            self.tags.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}
