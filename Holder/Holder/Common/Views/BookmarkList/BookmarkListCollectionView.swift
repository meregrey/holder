//
//  BookmarkListCollectionView.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/07.
//

import UIKit

final class BookmarkListCollectionView: UICollectionView {
    
    private let flowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = .zero
        layout.minimumLineSpacing = 12
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
        register(BookmarkListCollectionViewCell.self)
        register(UICollectionReusableView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: String(describing: UICollectionReusableView.self))
        register(UICollectionReusableView.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                 withReuseIdentifier: String(describing: UICollectionReusableView.self))
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .clear
    }
}
