//
//  RoundedCornerView.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/18.
//

import UIKit

final class RoundedCornerView: UIView {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
    }
}
