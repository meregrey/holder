//
//  BrowseRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol BrowseInteractable: Interactable, BookmarkListener, TagListener {
    var router: BrowseRouting? { get set }
    var listener: BrowseListener? { get set }
}

protocol BrowseViewControllable: ViewControllable {
    func addChild(_ viewController: ViewControllable)
    func push(_ viewController: ViewControllable)
    func pop()
    func presentOver(_ viewController: ViewControllable)
    func dismissOver()
}

final class BrowseRouter: ViewableRouter<BrowseInteractable, BrowseViewControllable>, BrowseRouting {
    
    private let bookmark: BookmarkBuildable
    private let tag: TagBuildable
    
    private var bookmarkRouter: BookmarkRouting?
    private var tagRouter: TagRouting?
    
    init(interactor: BrowseInteractable,
         viewController: BrowseViewControllable,
         bookmark: BookmarkBuildable,
         tag: TagBuildable) {
        self.bookmark = bookmark
        self.tag = tag
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachBookmark() {
        guard bookmarkRouter == nil else { return }
        let router = bookmark.build(withListener: interactor)
        bookmarkRouter = router
        attachChild(router)
    }
    
    func attachTag() {
        guard tagRouter == nil else { return }
        let router = tag.build(withListener: interactor)
        tagRouter = router
        attachChild(router)
    }
    
    func attachSelectTags(existingSelectedTags: [Tag]) {
        tagRouter?.attachSelectTags(existingSelectedTags: existingSelectedTags)
    }
}
