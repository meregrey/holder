//
//  NavigationController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/03.
//

import RIBs
import UIKit

final class NavigationController: UINavigationController, ViewControllable {
    
    private enum Font {
        static let navigationBarLargeTitle = UIFont.systemFont(ofSize: 26, weight: .bold)
    }
    
    private let paragraphStyle: NSMutableParagraphStyle = {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 6
        return paragraphStyle
    }()
    
    init(root: ViewControllable) {
        super.init(rootViewController: root.uiviewController)
        configureViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
    }
    
    private func configureViews() {
        navigationBar.isTranslucent = false
        navigationBar.prefersLargeTitles = true
        navigationBar.largeTitleTextAttributes = [.font: Font.navigationBarLargeTitle, .paragraphStyle: paragraphStyle]
    }
}
