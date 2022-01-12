//
//  NavigationController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/03.
//

import RIBs
import UIKit

protocol NavigationRootViewControllable: ViewControllable {
    func popGestureDidRecognize()
}

final class NavigationController: UINavigationController, ViewControllable {
    
    private var root: NavigationRootViewControllable?
    
    private enum Font {
        static let navigationBarLargeTitle = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    init?(root: ViewControllable) {
        guard let root = root as? NavigationRootViewControllable else { return nil }
        self.root = root
        super.init(rootViewController: root.uiviewController)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func configureViews() {
        navigationBar.barTintColor = .white
        navigationBar.tintColor = .black
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.font: Font.navigationBarLargeTitle]
        navigationBar.shadowImage = UIImage()
        interactivePopGestureRecognizer?.delegate = self
        interactivePopGestureRecognizer?.addTarget(self, action: #selector(popGestureDidRecognize(_:)))
    }
    
    @objc private func popGestureDidRecognize(_ gesture: UIGestureRecognizer) {
        if gesture.state == .ended {
            root?.popGestureDidRecognize()
        }
    }
}

extension NavigationController: UIGestureRecognizerDelegate {}
