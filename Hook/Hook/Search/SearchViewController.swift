//
//  SearchViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol SearchPresentableListener: AnyObject {}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {

    weak var listener: SearchPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        title = LocalizedString.ViewTitle.search
        tabBarItem = UITabBarItem(title: nil,
                                  image: UIImage(systemName: "magnifyingglass"),
                                  selectedImage: UIImage(systemName: "magnifyingglass"))
    }
}
