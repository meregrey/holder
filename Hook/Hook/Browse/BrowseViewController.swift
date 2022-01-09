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
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        return stackView
    }()
    
    private enum Image {
        static let tabBarItem = UIImage(systemName: "rectangle.grid.1x2")
        static let tabBarItemSelected = UIImage(systemName: "rectangle.grid.1x2.fill")
    }

    weak var listener: BrowsePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func addChild(_ view: ViewControllable) {
        let childViewController = view.uiviewController
        addChild(childViewController)
        stackView.addArrangedSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    private func configureViews() {
        tabBarItem = UITabBarItem(title: nil,
                                  image: Image.tabBarItem,
                                  selectedImage: Image.tabBarItemSelected)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
