//
//  AccountViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol AccountPresentableListener: AnyObject {}

final class AccountViewController: UIViewController, AccountPresentable, AccountViewControllable {
    
    private enum Image {
        static let tabBarItem = UIImage(named: "account")
    }

    weak var listener: AccountPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        title = LocalizedString.ViewTitle.account
        tabBarItem = UITabBarItem(title: nil,
                                  image: Image.tabBarItem,
                                  selectedImage: Image.tabBarItem)
        view.backgroundColor = Asset.Color.baseBackgroundColor
    }
}
