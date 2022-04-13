//
//  SettingsRouter.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsInteractable: Interactable, AppearanceListener, SortBookmarksListener, ClearDataListener {
    var router: SettingsRouting? { get set }
    var listener: SettingsListener? { get set }
}

protocol SettingsViewControllable: ViewControllable {
    func push(_ viewControllable: ViewControllable)
    func pop()
}

final class SettingsRouter: ViewableRouter<SettingsInteractable, SettingsViewControllable>, SettingsRouting {
    
    private let appearance: AppearanceBuildable
    private let sortBookmarks: SortBookmarksBuildable
    private let clearData: ClearDataBuildable
    
    private var appearanceRouter: AppearanceRouting?
    private var sortBookmarksRouter: SortBookmarksRouting?
    private var clearDataRouter: ClearDataRouting?
    
    init(interactor: SettingsInteractable,
         viewController: SettingsViewControllable,
         appearance: AppearanceBuildable,
         sortBookmarks: SortBookmarksBuildable,
         clearData: ClearDataBuildable) {
        self.appearance = appearance
        self.sortBookmarks = sortBookmarks
        self.clearData = clearData
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - Appearance
    
    func attachAppearance() {
        guard appearanceRouter == nil else { return }
        let router = appearance.build(withListener: interactor)
        appearanceRouter = router
        attachChild(router)
        viewController.push(router.viewControllable)
    }
    
    func detachAppearance(includingView isViewIncluded: Bool) {
        guard let router = appearanceRouter else { return }
        if isViewIncluded { viewController.pop() }
        detachChild(router)
        appearanceRouter = nil
    }
    
    // MARK: - SortBookmarks
    
    func attachSortBookmarks() {
        guard sortBookmarksRouter == nil else { return }
        let router = sortBookmarks.build(withListener: interactor)
        sortBookmarksRouter = router
        attachChild(router)
        viewController.push(router.viewControllable)
    }
    
    func detachSortBookmarks(includingView isViewIncluded: Bool) {
        guard let router = sortBookmarksRouter else { return }
        if isViewIncluded { viewController.pop() }
        detachChild(router)
        sortBookmarksRouter = nil
    }
    
    // MARK: - ClearData
    
    func attachClearData() {
        guard clearDataRouter == nil else { return }
        let router = clearData.build(withListener: interactor)
        clearDataRouter = router
        attachChild(router)
        viewController.push(router.viewControllable)
    }
    
    func detachClearData(includingView isViewIncluded: Bool) {
        guard let router = clearDataRouter else { return }
        if isViewIncluded { viewController.pop() }
        detachChild(router)
        clearDataRouter = nil
    }
}
