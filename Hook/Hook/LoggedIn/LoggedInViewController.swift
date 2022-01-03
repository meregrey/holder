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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func setViewControllers(_ viewControllers: [ViewControllable]) {
        super.setViewControllers(viewControllers.map(\.uiviewController), animated: false)
    }
    
    private func configureViews() {
        view.backgroundColor = .white
        tabBar.tintColor = .black
    }
}
