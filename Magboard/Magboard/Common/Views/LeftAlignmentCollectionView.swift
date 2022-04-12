//
//  LeftAlignmentCollectionView.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/02/07.
//

import UIKit

protocol LeftAlignmentCollectionViewListener: AnyObject {
    func maxYDidSet(_ maxY: CGFloat)
}

final class LeftAlignmentCollectionView: UICollectionView {
    
    var maxY = CGFloat(0) {
        didSet { listener?.maxYDidSet(maxY) }
    }
    
    weak var listener: LeftAlignmentCollectionViewListener?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: LeftAlignmentCollectionViewFlowLayout())
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        allowsSelection = false
        isScrollEnabled = false
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
    }
}
