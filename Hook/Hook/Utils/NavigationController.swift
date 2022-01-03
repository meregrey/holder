//
//  NavigationController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/03.
//

import RIBs
import UIKit

final class NavigationController: ViewControllable {

    let navigationController: UINavigationController

    var uiviewController: UIViewController { navigationController }

    init(root: ViewControllable) {
        self.navigationController = UINavigationController(rootViewController: root.uiviewController)
        navigationController.navigationBar.backgroundColor = .white
        navigationController.navigationBar.prefersLargeTitles = true
    }
}
