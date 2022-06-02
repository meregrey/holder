//
//  UIViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/04/14.
//

import UIKit

extension UIViewController {
    
    var preferredStatusBarStyle: UIStatusBarStyle { .default }
    
    func configureNavigationBar(backgroundColor: UIColor) {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = backgroundColor
        navigationBarAppearance.largeTitleTextAttributes = [.font: UIFont.systemFont(ofSize: 26, weight: .bold)]
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Asset.Color.primaryColor
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
