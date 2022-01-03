//
//  BrowseViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol BrowsePresentableListener: AnyObject {}

final class BrowseViewController: UIViewController, BrowsePresentable, BrowseViewControllable {

    weak var listener: BrowsePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        title = LocalizedString.ViewTitle.browse
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "rectangle.grid.1x2"), selectedImage: UIImage(systemName: "rectangle.grid.1x2.fill"))
    }
}
