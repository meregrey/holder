//
//  TagRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs

protocol TagInteractable: Interactable, TagBarListener, TagSettingsListener, EnterTagListener, EditTagsListener {
    var router: TagRouting? { get set }
    var listener: TagListener? { get set }
}

final class TagRouter: Router<TagInteractable>, TagRouting {
    
    private let baseViewController: BrowseViewControllable
    private let tagBar: TagBarBuildable
    private let tagSettings: TagSettingsBuildable
    private let enterTag: EnterTagBuildable
    private let editTags: EditTagsBuildable
    
    private var tagBarRouter: Routing?
    private var tagSettingsRouter: Routing?
    private var enterTagRouter: Routing?
    private var editTagsRouter: Routing?
    
    init(interactor: TagInteractable,
         baseViewController: BrowseViewControllable,
         tagBar: TagBarBuildable,
         tagSettings: TagSettingsBuildable,
         enterTag: EnterTagBuildable,
         editTags: EditTagsBuildable) {
        self.baseViewController = baseViewController
        self.tagBar = tagBar
        self.tagSettings = tagSettings
        self.enterTag = enterTag
        self.editTags = editTags
        super.init(interactor: interactor)
        interactor.router = self
    }
    
    func cleanupViews() {}
    
    // MARK: - TagBar
    
    func attachTagBar() {
        guard tagBarRouter == nil else { return }
        let router = tagBar.build(withListener: interactor)
        tagBarRouter = router
        attachChild(router)
        baseViewController.addChild(router.viewControllable)
    }
    
    // MARK: - TagSettings
    
    func attachTagSettings() {
        guard tagSettingsRouter == nil else { return }
        let router = tagSettings.build(withListener: interactor)
        tagSettingsRouter = router
        attachChild(router)
        baseViewController.push(router.viewControllable)
    }
    
    func detachTagSettings(includingView isIncludedView: Bool) {
        guard let router = tagSettingsRouter else { return }
        if isIncludedView { baseViewController.pop() }
        detachChild(router)
        tagSettingsRouter = nil
    }
    
    // MARK: - EnterTag
    
    func attachEnterTag(mode: EnterTagMode) {
        guard enterTagRouter == nil else { return }
        let router = enterTag.build(withListener: interactor, mode: mode)
        enterTagRouter = router
        attachChild(router)
        baseViewController.push(router.viewControllable)
    }
    
    func detachEnterTag(includingView isIncludedView: Bool) {
        guard let router = enterTagRouter else { return }
        if isIncludedView { baseViewController.pop() }
        detachChild(router)
        enterTagRouter = nil
    }
    
    // MARK: - EditTags
    
    func attachEditTags() {
        guard editTagsRouter == nil else { return }
        let router = editTags.build(withListener: interactor)
        editTagsRouter = router
        attachChild(router)
        baseViewController.push(router.viewControllable)
    }
    
    func detachEditTags(includingView isIncludedView: Bool) {
        guard let router = editTagsRouter else { return }
        if isIncludedView { baseViewController.pop() }
        detachChild(router)
        editTagsRouter = nil
    }
}
