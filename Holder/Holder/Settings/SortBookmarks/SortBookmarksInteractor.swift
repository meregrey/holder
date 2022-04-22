//
//  SortBookmarksInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import RIBs

protocol SortBookmarksRouting: ViewableRouting {}

protocol SortBookmarksPresentable: Presentable {
    var listener: SortBookmarksPresentableListener? { get set }
}

protocol SortBookmarksListener: AnyObject {
    func sortBookmarksBackButtonDidTap()
    func sortBookmarksDidRemove()
}

final class SortBookmarksInteractor: PresentableInteractor<SortBookmarksPresentable>, SortBookmarksInteractable, SortBookmarksPresentableListener {
    
    weak var router: SortBookmarksRouting?
    weak var listener: SortBookmarksListener?
    
    override init(presenter: SortBookmarksPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func backButtonDidTap() {
        listener?.sortBookmarksBackButtonDidTap()
    }
    
    func didRemove() {
        listener?.sortBookmarksDidRemove()
    }
}
