//
//  BookmarkBrowserCollectionViewCell.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/21.
//

import CoreData
import UIKit

final class BookmarkBrowserCollectionViewCell: UICollectionViewCell {
    
    @AutoLayout private var bookmarkListCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.minimumLineSpacing = Metric.bookmarkListCollectionViewLineSpacing
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(BookmarkListCollectionViewCell.self)
        collectionView.register(UICollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: String(describing: UICollectionReusableView.self))
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    private var bookmarkListCollectionViewManager: BookmarkListCollectionViewManager?
    
    private enum Metric {
        static let bookmarkListCollectionViewLineSpacing = CGFloat(12)
        static let bookmarkListCollectionViewLeading = CGFloat(20)
        static let bookmarkListCollectionViewTrailing = CGFloat(-20)
    }
    
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
        bookmarkListCollectionViewManager = nil
    }
    
    func configure(for tag: Tag, context: NSManagedObjectContext) {
        if bookmarkListCollectionViewManager == nil {
            bookmarkListCollectionViewManager = BookmarkListCollectionViewManager(collectionView: bookmarkListCollectionView,
                                                                                  tag: tag,
                                                                                  context: context)
        }
        bookmarkListCollectionView.dataSource = bookmarkListCollectionViewManager
        bookmarkListCollectionView.prefetchDataSource = bookmarkListCollectionViewManager
        bookmarkListCollectionView.delegate = bookmarkListCollectionViewManager
        bookmarkListCollectionView.reloadData()
    }
    
    func bookmarkListCollectionViewContentOffset() -> CGPoint {
        return bookmarkListCollectionView.contentOffset
    }
    
    func setBookmarkListCollectionViewContentOffset(_ contentOffset: CGPoint) {
        bookmarkListCollectionView.layoutIfNeeded()
        bookmarkListCollectionView.contentOffset = contentOffset
    }
    
    func resetBookmarkListCollectionViewContentOffset() {
        bookmarkListCollectionView.contentOffset = CGPoint.zero
    }
    
    private func configureViews() {
        contentView.addSubview(bookmarkListCollectionView)
        NSLayoutConstraint.activate([
            bookmarkListCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bookmarkListCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.bookmarkListCollectionViewLeading),
            bookmarkListCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.bookmarkListCollectionViewTrailing),
            bookmarkListCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
