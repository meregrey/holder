//
//  UIView.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/09.
//

import UIKit

extension UICollectionView {
    
    func register<T: UICollectionViewCell>(_ cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.reuseIdentifier, for: indexPath) as? T else { return T() }
        return cell
    }
}

extension UITableView {
    
    func register<T: UITableViewCell>(_ cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: T.reuseIdentifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else { return T() }
        return cell
    }
}

extension UIView {
    
    func adoptInterfaceStyle(_ interfaceStyle: InterfaceStyle) {
        switch interfaceStyle {
        case .systemSetting:
            overrideUserInterfaceStyle = .unspecified
        case .light:
            overrideUserInterfaceStyle = .light
        case .dark:
            overrideUserInterfaceStyle = .dark
        }
    }
}
