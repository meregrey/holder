//
//  AlertAction.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/14.
//

import UIKit

final class AlertAction: UIButton {
    
    init(title: String, handler: Selector) {
        super.init(frame: .zero)
        configure(with: title, handler: handler)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func configure(with title: String, handler: Selector) {
        titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        setTitle(title, for: .normal)
        setTitleColor(Asset.Color.primaryColor, for: .normal)
        addTarget(nil, action: handler, for: .touchUpInside)
    }
}
