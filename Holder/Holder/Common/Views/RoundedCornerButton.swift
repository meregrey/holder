//
//  RoundedCornerButton.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/13.
//

import UIKit

final class RoundedCornerButton: UIButton {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        layer.cornerRadius = 10
        layer.cornerCurve = .continuous
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        heightAnchor.constraint(equalToConstant: 55).isActive = true
    }
}
