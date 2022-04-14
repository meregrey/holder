//
//  RootViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs
import UIKit

protocol RootPresentableListener: AnyObject {}

final class RootViewController: UITabBarController, RootPresentable, RootViewControllable {
    
    weak var listener: RootPresentableListener?
    
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
