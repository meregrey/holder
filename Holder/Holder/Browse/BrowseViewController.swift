//
//  BrowseViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol BrowsePresentableListener: AnyObject {}

final class BrowseViewController: UIViewController, BrowsePresentable, BrowseViewControllable {
    
    weak var listener: BrowsePresentableListener?
    
    @AutoLayout private var bookmarkBrowserContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    @AutoLayout private var tagBarContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    @AutoLayout private var dummyView = UIView()
    
    private enum Image {
        static let tabBarItem = UIImage(named: "Browse")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        registerToReceiveNotification()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerToReceiveNotification()
        configureViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func addChild(_ viewController: ViewControllable) {
        let viewController = viewController.uiviewController
        addChild(viewController)
        addChildView(of: viewController)
        viewController.didMove(toParent: self)
    }
    
    func push(_ viewController: ViewControllable) {
        navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentOver(_ viewController: ViewControllable) {
        let viewController = viewController.uiviewController
        viewController.modalPresentationStyle = .currentContext
        presentedViewController?.present(viewController, animated: true)
    }
    
    func dismissOver() {
        presentedViewController?.dismiss(animated: true)
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(didFailToCheckStore),
                                       name: NotificationName.Store.didFailToCheck)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(didFailToLoadStore),
                                       name: NotificationName.Store.didFailToLoad)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(didFailToSaveStore),
                                       name: NotificationName.Store.didFailToSave)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(didFailToProcessData),
                                       name: NotificationName.didFailToProcessData)
    }
    
    @objc
    private func didFailToCheckStore() {
        presentAlert(title: LocalizedString.AlertTitle.errorOccurredWhileCheckingTheStore)
    }
    
    @objc
    private func didFailToLoadStore() {
        presentAlert(title: LocalizedString.AlertTitle.errorOccurredWhileLoadingTheStore)
    }
    
    @objc
    private func didFailToSaveStore() {
        presentAlert(title: LocalizedString.AlertTitle.errorOccurredWhileSavingToTheStore)
    }
    
    @objc
    private func didFailToProcessData() {
        presentAlert(title: LocalizedString.AlertTitle.errorOccurredWhileProcessingData)
    }
    
    private func configureViews() {
        tabBarItem = UITabBarItem(title: nil,
                                  image: Image.tabBarItem,
                                  selectedImage: Image.tabBarItem)
        
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        view.addSubview(bookmarkBrowserContainerView)
        view.addSubview(tagBarContainerView)
        bookmarkBrowserContainerView.addArrangedSubview(dummyView)
        
        NSLayoutConstraint.activate([
            bookmarkBrowserContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            bookmarkBrowserContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkBrowserContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarkBrowserContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            tagBarContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            tagBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tagBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dummyView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    private func addChildView(of viewController: UIViewController) {
        let containerView = viewController is BookmarkBrowserViewController ? bookmarkBrowserContainerView : tagBarContainerView
        containerView.addArrangedSubview(viewController.view)
    }
}
