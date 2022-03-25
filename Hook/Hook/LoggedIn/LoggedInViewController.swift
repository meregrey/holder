//
//  LoggedInViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol LoggedInPresentableListener: AnyObject {}

final class LoggedInViewController: UITabBarController, LoggedInPresentable, LoggedInViewControllable {
    
    weak var listener: LoggedInPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        let viewControllers = viewControllers.map { $0.uiviewController }
        viewControllers.forEach { $0.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -6, right: 0) }
        super.setViewControllers(viewControllers, animated: false)
    }
    
    private func configureViews() {
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        tabBar.standardAppearance = appearance
        tabBar.tintColor = Asset.Color.primaryColor
        tabBar.unselectedItemTintColor = Asset.Color.unselectedTabBarItemColor
        tabBar.backgroundColor = Asset.Color.baseBackgroundColor
    }
}
