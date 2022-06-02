//
//  NavigationController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/03.
//

import RIBs
import UIKit

final class NavigationController: UINavigationController, UIGestureRecognizerDelegate, ViewControllable {
    
    private enum Font {
        static let navigationBarLargeTitle = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    init(root: ViewControllable) {
        super.init(rootViewController: root.uiviewController)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func configureViews() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = Asset.Color.baseBackgroundColor
        navigationBarAppearance.largeTitleTextAttributes = [.font: Font.navigationBarLargeTitle]
        navigationBar.standardAppearance = navigationBarAppearance
        navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationBar.tintColor = Asset.Color.primaryColor
        navigationBar.prefersLargeTitles = true
        
        let toolbarAppearance = UIToolbarAppearance()
        toolbarAppearance.configureWithTransparentBackground()
        toolbarAppearance.backgroundEffect = UIBlurEffect(style: .prominent)
        toolbar.standardAppearance = toolbarAppearance
        toolbar.tintColor = Asset.Color.primaryColor
        
        interactivePopGestureRecognizer?.delegate = self
    }
}
