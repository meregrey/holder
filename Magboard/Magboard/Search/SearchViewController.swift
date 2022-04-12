//
//  SearchViewController.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol SearchPresentableListener: AnyObject {}

final class SearchViewController: UIViewController, SearchPresentable, SearchViewControllable {
    
    @AutoLayout private var contentContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    @AutoLayout private var searchBarContainerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    @AutoLayout private var dummyView = UIView()
    
    private lazy var contentContainerViewHeightConstraint = NSLayoutConstraint(item: contentContainerView,
                                                                               attribute: .height,
                                                                               relatedBy: .equal,
                                                                               toItem: nil,
                                                                               attribute: .notAnAttribute,
                                                                               multiplier: 1,
                                                                               constant: 0)
    
    private enum Image {
        static let tabBarItem = UIImage(named: "Search")
    }

    weak var listener: SearchPresentableListener?
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contentContainerViewHeightConstraint.constant = view.frame.height - view.safeAreaInsets.bottom
    }
    
    func addChild(_ viewControllable: ViewControllable) {
        let childViewController = viewControllable.uiviewController
        addChild(childViewController)
        addChildView(of: childViewController)
        childViewController.didMove(toParent: self)
    }
    
    func removeChild(_ viewControllable: ViewControllable) {
        let childViewController = viewControllable.uiviewController
        if childViewController is SearchBarViewController { return }
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
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
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: UIResponder.keyboardWillShowNotification)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let constant = view.frame.height - keyboardFrame.height
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.contentContainerViewHeightConstraint.constant = constant
            self.view.layoutIfNeeded()
        }
    }
    
    @objc
    private func keyboardWillHide() {
        let constant = view.frame.height - view.safeAreaInsets.bottom
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.contentContainerViewHeightConstraint.constant = constant
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureViews() {
        tabBarItem = UITabBarItem(title: nil,
                                  image: Image.tabBarItem,
                                  selectedImage: Image.tabBarItem)
        
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        view.addSubview(contentContainerView)
        view.addSubview(searchBarContainerView)
        contentContainerView.addArrangedSubview(dummyView)
        
        contentContainerViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            contentContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            contentContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            searchBarContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            searchBarContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            dummyView.heightAnchor.constraint(equalToConstant: 0)
        ])
    }
    
    private func addChildView(of childViewController: UIViewController) {
        let containerView = childViewController is SearchBarViewController ? searchBarContainerView : contentContainerView
        containerView.addArrangedSubview(childViewController.view)
    }
}