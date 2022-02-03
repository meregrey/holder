//
//  NavigationBar.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import UIKit

final class NavigationBar: UINavigationBar {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Asset.Color.sheetBackgroundColor
        standardAppearance = appearance
        scrollEdgeAppearance = appearance
        tintColor = Asset.Color.primaryColor
    }
}
