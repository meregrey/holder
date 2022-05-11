//
//  LeftAlignmentCollectionView.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/07.
//

import UIKit

protocol LeftAlignmentCollectionViewListener: AnyObject {
    func maxYDidSet(_ maxY: CGFloat)
}

final class LeftAlignmentCollectionView: UICollectionView {
    
    weak var listener: LeftAlignmentCollectionViewListener?
    
    var maxY = CGFloat(0) {
        didSet { listener?.maxYDidSet(maxY) }
    }
    
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
