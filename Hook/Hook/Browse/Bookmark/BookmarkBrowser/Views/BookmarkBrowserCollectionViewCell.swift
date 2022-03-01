//
//  BookmarkBrowserCollectionViewCell.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/21.
//

import CoreData
import UIKit

final class BookmarkBrowserCollectionViewCell: UICollectionViewCell {
    
    @AutoLayout private var bookmarkListTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(BookmarkListTableViewCell.self)
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    private let bookmarkListTableViewDelegate = BookmarkListTableViewDelegate()
    private var bookmarkListTableViewDataSource: BookmarkListTableViewDataSource?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bookmarkListTableViewDataSource = nil
    }
    
    func configure(for tag: Tag, context: NSManagedObjectContext) {
        if bookmarkListTableViewDataSource == nil {
            bookmarkListTableViewDataSource = BookmarkListTableViewDataSource(tableView: bookmarkListTableView,
                                                                              tag: tag,
                                                                              context: context)
        }
        bookmarkListTableView.dataSource = bookmarkListTableViewDataSource
        bookmarkListTableView.delegate = bookmarkListTableViewDelegate
        bookmarkListTableView.reloadData()
    }
    
    func bookmarkListTableViewContentOffset() -> CGPoint {
        return bookmarkListTableView.contentOffset
    }
    
    func setBookmarkListTableViewContentOffset(_ contentOffset: CGPoint) {
        bookmarkListTableView.layoutIfNeeded()
        bookmarkListTableView.contentOffset = contentOffset
    }
    
    func resetBookmarkListTableViewContentOffset() {
        bookmarkListTableView.contentOffset = CGPoint.zero
    }
    
    private func configureViews() {
        contentView.addSubview(bookmarkListTableView)
        NSLayoutConstraint.activate([
            bookmarkListTableView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookmarkListTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bookmarkListTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bookmarkListTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
