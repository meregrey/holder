//
//  BrowseInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol BrowseRouting: ViewableRouting {
    func attachTag()
    func detachTop(for content: BrowseContent)
}

protocol BrowsePresentable: Presentable {
    var listener: BrowsePresentableListener? { get set }
}

protocol BrowseListener: AnyObject {}

final class BrowseInteractor: PresentableInteractor<BrowsePresentable>, BrowseInteractable, BrowsePresentableListener {
    
    private var currentTopContent: BrowseContent?

    weak var router: BrowseRouting?
    weak var listener: BrowseListener?
    
    override init(presenter: BrowsePresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTag()
    }

    override func willResignActive() {
        super.willResignActive()
    }
    
    func setCurrentTopContent(_ content: BrowseContent?) {
        currentTopContent = content
    }
    
    func popGestureDidRecognize() {
        guard let currentTopContent = currentTopContent else { return }
        router?.detachTop(for: currentTopContent)
    }
}
