//
//  ShareRouter.swift
//  ShareExtension
//
//  Created by Yeojin Yoon on 2022/04/19.
//

import RIBs

protocol ShareInteractable: Interactable, SelectTagsListener, SearchTagsListener {
    var router: ShareRouting? { get set }
    var listener: ShareListener? { get set }
}

protocol ShareViewControllable: ViewControllable {
    func update(with selectedTags: [Tag])
    func completeRequest()
}

final class ShareRouter: Router<ShareInteractable>, ShareRouting {
    
    private let viewController: ShareViewControllable
    private let selectTags: SelectTagsBuildable
    private let searchTags: SearchTagsBuildable
    
    private var selectTagsRouter: SelectTagsRouting?
    private var searchTagsRouter: SearchTagsRouting?
    
    init(interactor: ShareInteractable,
         viewController: ShareViewControllable,
         selectTags: SelectTagsBuildable,
         searchTags: SearchTagsBuildable) {
        self.viewController = viewController
        self.selectTags = selectTags
        self.searchTags = searchTags
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func cleanupViews() {}
    
    // MARK: - SelectTags
    
    func attachSelectTags(existingSelectedTags: [Tag]) {
        guard selectTagsRouter == nil else { return }
        let router = selectTags.build(withListener: interactor,
                                      existingSelectedTags: existingSelectedTags,
                                      topBarStyle: .navigation,
                                      forNavigation: false)
        selectTagsRouter = router
        attachChild(router)
        viewController.present(router.viewControllable,
                               modalPresentationStyle: .currentContext,
                               animated: true)
    }
    
    func detachSelectTags() {
        guard let router = selectTagsRouter else { return }
        viewController.dismiss(animated: true)
        detachChild(router)
        selectTagsRouter = nil
    }
    
    // MARK: - SearchTags
    
    func attachSearchTags() {
        guard searchTagsRouter == nil else { return }
        guard let selectTagsRouter = selectTagsRouter else { return }
        let router = searchTags.build(withListener: interactor, forNavigation: false)
        searchTagsRouter = router
        attachChild(router)
        selectTagsRouter.viewControllable.present(router.viewControllable,
                                                  modalPresentationStyle: .currentContext,
                                                  animated: true)
    }
    
    func detachSearchTags() {
        guard let router = searchTagsRouter else { return }
        router.viewControllable.dismiss(animated: true)
        detachChild(router)
        searchTagsRouter = nil
    }
}
