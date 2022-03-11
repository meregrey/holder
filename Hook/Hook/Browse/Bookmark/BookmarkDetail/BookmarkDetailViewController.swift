//
//  BookmarkDetailViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/11.
//

import RIBs
import UIKit

protocol BookmarkDetailPresentableListener: AnyObject {
    func didRemove()
}

final class BookmarkDetailViewController: UIViewController, BookmarkDetailPresentable, BookmarkDetailViewControllable {
    
    weak var listener: BookmarkDetailPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    private func configureViews() {
        hidesBottomBarWhenPushed = true
    }
}
