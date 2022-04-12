//
//  LeftAlignmentCollectionViewFlowLayout.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/02/07.
//

import UIKit

final class LeftAlignmentCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributes = super.layoutAttributesForElements(in: rect) else { return nil }
        let cellAttributes = attributes.filter { $0.representedElementCategory == .cell }
        var x = CGFloat(0)
        var y = CGFloat(0)
        
        cellAttributes.forEach {
            if $0.frame.origin.y >= y { x = sectionInset.left }
            $0.frame.origin.x = x
            x += $0.frame.width + minimumInteritemSpacing
            y = $0.frame.maxY
        }
        
        guard let collectionView = collectionView as? LeftAlignmentCollectionView else { return cellAttributes }
        collectionView.maxY = y
        
        return cellAttributes
    }
    
    private func configure() {
        minimumLineSpacing = 8
        minimumInteritemSpacing = 8
    }
}
