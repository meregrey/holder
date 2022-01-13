//
//  TagRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs

protocol TagInteractable: Interactable, TagBarListener, TagSettingsListener, EnterTagListener {
    var router: TagRouting? { get set }
    var listener: TagListener? { get set }
    func reportCurrentTopContent(_ content: BrowseContent?)
}

final class TagRouter: Router<TagInteractable>, TagRouting {
    
    private let baseViewController: BrowseViewControllable
    private let tagBar: TagBarBuildable
    private let tagSettings: TagSettingsBuildable
    private let enterTag: EnterTagBuildable
    
    private var tagBarRouter: Routing?
    private var tagSettingsRouter: Routing?
    private var enterTagRouter: Routing?
    
    init(interactor: TagInteractable,
         baseViewController: BrowseViewControllable,
         tagBar: TagBarBuildable,
         tagSettings: TagSettingsBuildable,
         enterTag: EnterTagBuildable) {
        self.baseViewController = baseViewController
        self.tagBar = tagBar
        self.tagSettings = tagSettings
        self.enterTag = enterTag
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
    
    func attachTagSettings() {
        guard tagSettingsRouter == nil else { return }
        let router = tagSettings.build(withListener: interactor)
        tagSettingsRouter = router
        attachChild(router)
        baseViewController.push(router.viewControllable)
        interactor.reportCurrentTopContent(.tag)
    }
    
    func detachTagSettings() {
        guard let router = tagSettingsRouter else { return }
        baseViewController.pop()
        detachChild(router)
        tagSettingsRouter = nil
        interactor.reportCurrentTopContent(nil)
    }
    
    func attachEnterTag() {
        guard enterTagRouter == nil else { return }
        let router = enterTag.build(withListener: interactor)
        enterTagRouter = router
        attachChild(router)
        baseViewController.push(router.viewControllable)
    }
    
    func detachEnterTag() {
        guard let router = enterTagRouter else { return }
        baseViewController.pop()
        detachChild(router)
        enterTagRouter = nil
    }
    
    func detachTop() {
        guard let router = children.last else { return }
        detachChild(router)
        
        if let _ = router as? TagSettingsRouting {
            tagSettingsRouter = nil
            interactor.reportCurrentTopContent(nil)
        }
        
        if let _ = router as? EnterTagRouting {
            enterTagRouter = nil
        }
    }

    func cleanupViews() {}
}
