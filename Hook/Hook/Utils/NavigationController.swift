//
//  NavigationController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/03.
//

import RIBs
import UIKit

final class NavigationController: UINavigationController, ViewControllable {
    
    init(root: ViewControllable) {
        super.init(rootViewController: root.uiviewController)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func configureViews() {
        navigationBar.prefersLargeTitles = true
    }
}
