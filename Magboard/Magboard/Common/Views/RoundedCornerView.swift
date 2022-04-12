//
//  RoundedCornerView.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/01/18.
//

import UIKit

class RoundedCornerView: UIView {
    
    init(cornerRadius: CGFloat = 15) {
        super.init(frame: .zero)
        configure(cornerRadius: cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(cornerRadius: 15)
    }
    
    private func configure(cornerRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = .continuous
    }
}
