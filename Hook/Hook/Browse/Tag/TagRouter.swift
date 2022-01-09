//
//  TagRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs

protocol TagInteractable: Interactable, TagBarListener {
    var router: TagRouting? { get set }
    var listener: TagListener? { get set }
}

final class TagRouter: Router<TagInteractable>, TagRouting {
    
    private let baseViewController: BrowseViewControllable
    private let tagBar: TagBarBuildable
    
    private var tagBarRouter: Routing?
    
    init(interactor: TagInteractable,
         baseViewController: BrowseViewControllable,
         tagBar: TagBarBuildable) {
        self.baseViewController = baseViewController
        self.tagBar = tagBar
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func attachTagBar() {
        guard tagBarRouter == nil else { return }
        let router = tagBar.build(withListener: interactor)
        tagBarRouter = router
        attachChild(router)
        baseViewController.addChild(router.viewControllable)
    }

    func cleanupViews() {}
}
