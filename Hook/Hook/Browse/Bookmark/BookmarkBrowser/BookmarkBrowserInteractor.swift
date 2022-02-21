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

protocol BookmarkBrowserInteractorDependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
    var currentTagStream: MutableStream<Tag> { get }
}

final class BookmarkBrowserInteractor: PresentableInteractor<BookmarkBrowserPresentable>, BookmarkBrowserInteractable, BookmarkBrowserPresentableListener {
    
    private let dependency: BookmarkBrowserInteractorDependency
    
    private var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
    private var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
    
    weak var router: BookmarkBrowserRouting?
    weak var listener: BookmarkBrowserListener?
    
    init(presenter: BookmarkBrowserPresentable, dependency: BookmarkBrowserInteractorDependency) {
        self.dependency = dependency
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
