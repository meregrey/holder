//
//  BookmarkBrowserCollectionView.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/05/03.
//

import UIKit

final class BookmarkBrowserCollectionView: UICollectionView {
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = .zero
        return layout
    }()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: flowLayout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        register(BookmarkBrowserCollectionViewCell.self)
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
    }
}
