//
//  SingleButtonNavigationBar.swift
//  ShareExtension
//
//  Created by Yeojin Yoon on 2022/04/20.
//

import UIKit

protocol SingleButtonNavigationBarListener: AnyObject {
    func cancelButtonDidTap()
}

final class SingleButtonNavigationBar: UINavigationBar {
    
    weak var listener: SingleButtonNavigationBarListener?
    
    private let item = UINavigationItem()
    
    private let cancelButton = UIBarButtonItem(title: LocalizedString.ActionTitle.cancel, style: .plain, target: nil, action: #selector(cancelButtonDidTap))
    
    private let appearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        return appearance
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        configure(with: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(with: "")
    }
    
    private func configure(with title: String) {
        item.title = title
        item.rightBarButtonItem = cancelButton
        items = [item]
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        tintColor = Asset.Color.primaryColor
    }
    
    @objc
    private func cancelButtonDidTap() {
        listener?.cancelButtonDidTap()
    }
}
