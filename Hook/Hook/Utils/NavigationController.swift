//
//  NavigationController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/03.
//

import RIBs
import UIKit

final class NavigationController: UINavigationController, ViewControllable {
    
    private enum Font {
        static let navigationBarLargeTitle = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    init?(root: ViewControllable) {
        super.init(rootViewController: root.uiviewController)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func configureViews() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = Asset.Color.baseBackgroundColor
        appearance.largeTitleTextAttributes = [.font: Font.navigationBarLargeTitle]
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = Asset.Color.primaryColor
        navigationBar.prefersLargeTitles = true
        interactivePopGestureRecognizer?.delegate = self
    }
}

extension NavigationController: UIGestureRecognizerDelegate {}
