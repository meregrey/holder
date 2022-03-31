//
//  BookmarkDetailRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/11.
//

import RIBs

protocol BookmarkDetailInteractable: Interactable, BookmarkDetailSheetListener {
    var router: BookmarkDetailRouting? { get set }
    var listener: BookmarkDetailListener? { get set }
}

protocol BookmarkDetailViewControllable: ViewControllable {}

final class BookmarkDetailRouter: ViewableRouter<BookmarkDetailInteractable, BookmarkDetailViewControllable>, BookmarkDetailRouting {
    
    private let bookmarkDetailSheet: BookmarkDetailSheetBuildable
    
    private var bookmarkDetailSheetRouter: BookmarkDetailSheetRouting?
    
    init(interactor: BookmarkDetailInteractable,
         viewController: BookmarkDetailViewControllable,
         bookmarkDetailSheet: BookmarkDetailSheetBuildable) {
        self.bookmarkDetailSheet = bookmarkDetailSheet
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachBookmarkDetailSheet() {
        guard bookmarkDetailSheetRouter == nil else { return }
        let router = bookmarkDetailSheet.build(withListener: interactor)
        bookmarkDetailSheetRouter = router
        attachChild(router)
        viewController.present(router.viewControllable, modalPresentationStyle: .overCurrentContext)
    }
    
    func detachBookmarkDetailSheet() {
        guard let router = bookmarkDetailSheetRouter else { return }
        viewController.dismiss(animated: false)
        detachChild(router)
        bookmarkDetailSheetRouter = nil
    }
}
