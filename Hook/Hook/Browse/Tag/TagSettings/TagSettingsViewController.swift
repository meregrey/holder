//
//  TagSettingsViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import RIBs
import UIKit

protocol TagSettingsPresentableListener: AnyObject {
    func backButtonDidTap()
    func addTagButtonDidTap()
    func editTagsButtonDidTap()
    func editTagTableViewRowDidSelect(tag: Tag)
    func didRemove()
}

final class TagSettingsViewController: UIViewController, TagSettingsPresentable, TagSettingsViewControllable {
    
    private var tags: [Tag] = []
    
    @AutoLayout private var editTagTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TagSettingsTableViewCell.self)
        tableView.tableHeaderView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = Asset.Color.baseBackgroundColor
        return tableView
    }()
    
    private enum Image {
        static let back = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        static let plus = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        static let ellipsis = UIImage(systemName: "ellipsis", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let editTagTableViewRowHeight = CGFloat(80)
    }
    
    weak var listener: TagSettingsPresentableListener?
    
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
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    func update(with tags: [Tag]) {
        self.tags = tags
        DispatchQueue.main.async {
            self.editTagTableView.reloadData()
        }
    }
    
    func scrollToBottom() {
        let indexPath = IndexPath(row: tags.count - 1, section: 0)
        DispatchQueue.main.async {
            self.editTagTableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    private func configureViews() {
        editTagTableView.dataSource = self
        editTagTableView.delegate = self
        
        title = LocalizedString.ViewTitle.tagSettings
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.back, style: .done, target: self, action: #selector(backButtonDidTap))
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: Image.ellipsis, style: .plain, target: self, action: #selector(editTagsButtonDidTap)),
                                              UIBarButtonItem(image: Image.plus, style: .plain, target: self, action: #selector(addTagButtonDidTap))]
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        view.addSubview(editTagTableView)
        
        NSLayoutConstraint.activate([
            editTagTableView.topAnchor.constraint(equalTo: view.topAnchor),
            editTagTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editTagTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editTagTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func backButtonDidTap() {
        listener?.backButtonDidTap()
    }
    
    @objc private func addTagButtonDidTap() {
        listener?.addTagButtonDidTap()
    }
    
    @objc private func editTagsButtonDidTap() {
        listener?.editTagsButtonDidTap()
    }
}

extension TagSettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TagSettingsTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        cell.configure(with: tags[indexPath.row])
        return cell
    }
}

extension TagSettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.editTagTableViewRowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tag = tags[indexPath.row]
        if tag.name == TagName.all { return }
        listener?.editTagTableViewRowDidSelect(tag: tag)
    }
}
