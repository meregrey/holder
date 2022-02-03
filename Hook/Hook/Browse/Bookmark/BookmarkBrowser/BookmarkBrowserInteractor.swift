//
//  BookmarkBrowserInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs

protocol BookmarkBrowserRouting: ViewableRouting {}

protocol BookmarkBrowserPresentable: Presentable {
    var listener: BookmarkBrowserPresentableListener? { get set }
}

protocol BookmarkBrowserListener: AnyObject {
    func bookmarkBrowserAddBookmarkButtonDidTap()
}

final class BookmarkBrowserInteractor: PresentableInteractor<BookmarkBrowserPresentable>, BookmarkBrowserInteractable, BookmarkBrowserPresentableListener {
    
    weak var router: BookmarkBrowserRouting?
    weak var listener: BookmarkBrowserListener?
    
    override init(presenter: BookmarkBrowserPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func addBookmarkButtonDidTap() {
        listener?.bookmarkBrowserAddBookmarkButtonDidTap()
    }
}
