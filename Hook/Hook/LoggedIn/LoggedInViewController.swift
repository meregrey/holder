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
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
    
    private func configureViews() {
        tabBar.tintColor = Asset.Color.primaryColor
    }
}
