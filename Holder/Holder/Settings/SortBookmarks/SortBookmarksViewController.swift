//
//  SortBookmarksViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import RIBs
import UIKit

protocol SortBookmarksPresentableListener: AnyObject {
    func backButtonDidTap()
    func didRemove()
}

final class SortBookmarksViewController: UIViewController, SortBookmarksPresentable, SortBookmarksViewControllable {
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    @AutoLayout private var newestToOldestSelectionView = SelectionView(title: LocalizedString.ActionTitle.newestToOldest)
    @AutoLayout private var oldestToNewestSelectionView = SelectionView(title: LocalizedString.ActionTitle.oldestToNewest)
    
    private enum Image {
        static let back = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let stackViewTop = CGFloat(20)
        static let stackViewLeading = CGFloat(20)
        static let stackViewTrailing = CGFloat(-20)
    }
    
    weak var listener: SortBookmarksPresentableListener?
    
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
        select()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    private func configureViews() {
        title = LocalizedString.ViewTitle.sortBookmarks
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.back, style: .done, target: self, action: #selector(backButtonDidTap))
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        newestToOldestSelectionView.addTarget(self, action: #selector(newestToOldestSelectionViewDidTap), for: .touchUpInside)
        oldestToNewestSelectionView.addTarget(self, action: #selector(oldestToNewestSelectionViewDidTap), for: .touchUpInside)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(newestToOldestSelectionView)
        stackView.addArrangedSubview(oldestToNewestSelectionView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.stackViewTrailing)
        ])
    }
    
    private func select() {
        let sort = UserDefaults.value(forType: Sort.self) ?? .newestToOldest
        newestToOldestSelectionView.select(sort == .newestToOldest)
        oldestToNewestSelectionView.select(sort == .oldestToNewest)
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.backButtonDidTap()
    }
    
    @objc
    private func newestToOldestSelectionViewDidTap() {
        handleSort(.newestToOldest)
    }
    
    @objc
    private func oldestToNewestSelectionViewDidTap() {
        handleSort(.oldestToNewest)
    }
    
    private func handleSort(_ sort: Sort) {
        UserDefaults.set(sort)
        NotificationCenter.post(named: NotificationName.Bookmark.sortDidChange)
        select()
    }
}
