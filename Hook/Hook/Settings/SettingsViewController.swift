//
//  SettingsViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs
import UIKit

protocol SettingsPresentableListener: AnyObject {}

final class SettingsViewController: UIViewController, SettingsPresentable, SettingsViewControllable {
    
    private enum Image {
        static let tabBarItem = UIImage(named: "settings")
    }
    
    weak var listener: SettingsPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    private func configureViews() {
        tabBarItem = UITabBarItem(title: nil,
                                  image: Image.tabBarItem,
                                  selectedImage: Image.tabBarItem)
        
        view.backgroundColor = Asset.Color.baseBackgroundColor
    }
}
