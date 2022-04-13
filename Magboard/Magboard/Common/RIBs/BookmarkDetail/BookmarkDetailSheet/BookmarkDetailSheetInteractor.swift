//
//  BookmarkDetailSheetInteractor.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/16.
//

import RIBs

protocol BookmarkDetailSheetRouting: ViewableRouting {}

protocol BookmarkDetailSheetPresentable: Presentable {
    var listener: BookmarkDetailSheetPresentableListener? { get set }
}

protocol BookmarkDetailSheetListener: AnyObject {
    func bookmarkDetailSheetDidRequestToDetach()
    func bookmarkDetailSheetReloadActionDidTap()
    func bookmarkDetailSheetEditActionDidTap()
    func bookmarkDetailSheetDeleteActionDidTap()
}

final class BookmarkDetailSheetInteractor: PresentableInteractor<BookmarkDetailSheetPresentable>, BookmarkDetailSheetInteractable, BookmarkDetailSheetPresentableListener {
    
    weak var router: BookmarkDetailSheetRouting?
    weak var listener: BookmarkDetailSheetListener?
    
    override init(presenter: BookmarkDetailSheetPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func didRequestToDetach() {
        listener?.bookmarkDetailSheetDidRequestToDetach()
    }
    
    func reloadActionDidTap() {
        listener?.bookmarkDetailSheetReloadActionDidTap()
    }
    
    func editActionDidTap() {
        listener?.bookmarkDetailSheetEditActionDidTap()
    }
    
    func deleteActionDidTap() {
        listener?.bookmarkDetailSheetDeleteActionDidTap()
    }
}
