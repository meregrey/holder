//
//  BrowseRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol BrowseInteractable: Interactable, TagListener, BookmarkListener {
    var router: BrowseRouting? { get set }
    var listener: BrowseListener? { get set }
}

protocol BrowseViewControllable: ViewControllable {
    func addChild(_ viewControllable: ViewControllable)
    func push(_ viewControllable: ViewControllable)
    func pop()
    func presentOver(_ viewControllable: ViewControllable)
    func dismissOver()
}

final class BrowseRouter: ViewableRouter<BrowseInteractable, BrowseViewControllable>, BrowseRouting {
    
    private let tag: TagBuildable
    private let bookmark: BookmarkBuildable
    
    private var tagRouter: TagRouting?
    private var bookmarkRouter: BookmarkRouting?
    
    init(interactor: BrowseInteractable,
         viewController: BrowseViewControllable,
         tag: TagBuildable,
         bookmark: BookmarkBuildable) {
        self.tag = tag
        self.bookmark = bookmark
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTag() {
        guard tagRouter == nil else { return }
        let router = tag.build(withListener: interactor)
        tagRouter = router
        attachChild(router)
    }
    
    func attachBookmark() {
        guard bookmarkRouter == nil else { return }
        let router = bookmark.build(withListener: interactor)
        bookmarkRouter = router
        attachChild(router)
    }
    
    func attachSelectTags(existingSelectedTags: [Tag]) {
        tagRouter?.attachSelectTags(existingSelectedTags: existingSelectedTags)
    }
}
