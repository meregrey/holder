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
        static let tabBarItem = UIImage(systemName: "rectangle.grid.1x2")?.withTintColor(Asset.Color.secondaryColor, renderingMode: .alwaysOriginal)
        static let tabBarItemSelected = UIImage(systemName: "rectangle.grid.1x2.fill")?.withTintColor(Asset.Color.primaryColor, renderingMode: .alwaysOriginal)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func addChild(_ view: ViewControllable) {
        let childViewController = view.uiviewController
        addChild(childViewController)
        stackView.addArrangedSubview(childViewController.view)
        childViewController.didMove(toParent: self)
    }
    
    func push(_ view: ViewControllable) {
        navigationController?.pushViewController(view.uiviewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentOver(_ view: ViewControllable) {
        let viewController = view.uiviewController
        viewController.modalPresentationStyle = .currentContext
        presentedViewController?.present(viewController, animated: true)
    }
    
    func dismissOver() {
        presentedViewController?.dismiss(animated: true)
    }
    
    private func configureViews() {
        tabBarItem = UITabBarItem(title: nil,
                                  image: Image.tabBarItem,
                                  selectedImage: Image.tabBarItemSelected)
        
        view.backgroundColor = Asset.Color.baseBackgroundColor
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
