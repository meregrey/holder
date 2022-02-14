//
//  BookmarkBrowserViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs
import UIKit

protocol BookmarkBrowserPresentableListener: AnyObject {
    func addBookmarkButtonDidTap()
}

final class BookmarkBrowserViewController: UIViewController, BookmarkBrowserPresentable, BookmarkBrowserViewControllable {
    
    @AutoLayout private var containerView = UIView()
    
    @AutoLayout private var addBookmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizedString.ButtonTitle.add, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.titleLabel?.font = Font.addBookmarkButton
        button.backgroundColor = Asset.Color.primaryColor
        button.layer.cornerRadius = Metric.addBookmarkButtonHeight / 2
        button.addTarget(self, action: #selector(addBookmarkButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private enum Font {
        static let addBookmarkButton = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    private enum Metric {
        static let addBookmarkButtonWidth = CGFloat(80)
        static let addBookmarkButtonHeight = CGFloat(50)
        static let addBookmarkButtonBottom = CGFloat(-20)
    }
    
    weak var listener: BookmarkBrowserPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    private func configureViews() {
        view.addSubview(containerView)
        containerView.addSubview(addBookmarkButton)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addBookmarkButton.widthAnchor.constraint(equalToConstant: Metric.addBookmarkButtonWidth),
            addBookmarkButton.heightAnchor.constraint(equalToConstant: Metric.addBookmarkButtonHeight),
            addBookmarkButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            addBookmarkButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Metric.addBookmarkButtonBottom)
        ])
    }
    
    @objc
    private func addBookmarkButtonDidTap() {
        listener?.addBookmarkButtonDidTap()
    }
}
