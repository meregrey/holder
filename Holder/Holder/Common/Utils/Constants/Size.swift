//
//  Size.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/02.
//

import UIKit

enum Size {
    static let safeAreaTopInset: CGFloat = {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return 0 }
        guard let window = windowScene.windows.first else { return 0 }
        return window.safeAreaInsets.top
    }()
    static let tagBarHeight = CGFloat(50)
    static let thumbnail = CGSize(width: 90, height: 60)
    static let searchBarViewHeight = SearchBar.height + SearchBarViewController.searchBarTop + SearchBarViewController.searchBarBottom
}
