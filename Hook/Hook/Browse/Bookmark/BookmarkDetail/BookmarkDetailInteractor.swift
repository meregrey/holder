//
//  BookmarkDetailInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/11.
//

import RIBs

protocol BookmarkDetailRouting: ViewableRouting {}

protocol BookmarkDetailPresentable: Presentable {
    var listener: BookmarkDetailPresentableListener? { get set }
}

protocol BookmarkDetailListener: AnyObject {
    func bookmarkDetailDidRemove()
}

protocol BookmarkDetailInteractorDependency {
    var bookmarkEntity: BookmarkEntity { get }
}

final class BookmarkDetailInteractor: PresentableInteractor<BookmarkDetailPresentable>, BookmarkDetailInteractable, BookmarkDetailPresentableListener {
    
    private let dependency: BookmarkDetailInteractorDependency
    
    private var bookmarkEntity: BookmarkEntity { dependency.bookmarkEntity }
    
    weak var router: BookmarkDetailRouting?
    weak var listener: BookmarkDetailListener?
    
    init(presenter: BookmarkDetailPresentable, dependency: BookmarkDetailInteractorDependency) {
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
    
    func didRemove() {
        listener?.bookmarkDetailDidRemove()
    }
}
