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
    
    @AutoLayout private var bookmarkBrowserContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    @AutoLayout private var tagBarContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        return stackView
    }()
    
    @AutoLayout private var dummyView = UIView()
    
    private enum Image {
        static let tabBarItem = UIImage(named: "browse.fill")
    }
    
    weak var listener: BrowsePresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
        registerToReceiveNotification()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
        registerToReceiveNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func addChild(_ viewControllable: ViewControllable) {
        let childViewController = viewControllable.uiviewController
        addChild(childViewController)
        addChildView(of: childViewController)
        childViewController.didMove(toParent: self)
    }
    
    func push(_ viewControllable: ViewControllable) {
        navigationController?.pushViewController(viewControllable.uiviewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentOver(_ viewControllable: ViewControllable) {
        let viewController = viewControllable.uiviewController
        viewController.modalPresentationStyle = .currentContext
        presentedViewController?.present(viewController, animated: true)
    }
    
    func dismissOver() {
        presentedViewController?.dismiss(animated: true)
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
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(didFailToAddExistingBookmark),
                                       name: NotificationName.Bookmark.existingBookmark)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(didFailToCheckStore),
                                       name: NotificationName.Store.didFailToCheck)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(didFailToSaveStore),
                                       name: NotificationName.Store.didFailToSave)
    }
    
    private func addChildView(of childViewController: UIViewController) {
        let containerView = childViewController is BookmarkBrowserViewController ? bookmarkBrowserContainerView : tagBarContainerView
        containerView.addArrangedSubview(childViewController.view)
    }
    
    @objc
    private func didFailToAddExistingBookmark() {
        presentAlert(title: LocalizedString.AlertTitle.bookmarkCorrespondingToTheLinkExists)
    }
    
    @objc
    private func didFailToCheckStore() {
        presentAlert(title: LocalizedString.AlertTitle.errorOccurredWhileCheckingTheStore)
    }
    
    @objc
    private func didFailToSaveStore() {
        presentAlert(title: LocalizedString.AlertTitle.errorOccurredWhileSavingToTheStore)
    }
}
