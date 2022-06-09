//
//  SettingsRouter.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsInteractable: Interactable, EnableSharingListener, AppearanceListener, SortBookmarksListener, ClearDataListener, VersionListener {
    var router: SettingsRouting? { get set }
    var listener: SettingsListener? { get set }
}

protocol SettingsViewControllable: ViewControllable {
    func push(_ viewController: ViewControllable)
    func pop()
}

final class SettingsRouter: ViewableRouter<SettingsInteractable, SettingsViewControllable>, SettingsRouting {
    
    private let enableSharing: EnableSharingBuildable
    private let appearance: AppearanceBuildable
    private let sortBookmarks: SortBookmarksBuildable
    private let clearData: ClearDataBuildable
    private let version: VersionBuildable
    
    private var enableSharingRouter: EnableSharingRouting?
    private var appearanceRouter: AppearanceRouting?
    private var sortBookmarksRouter: SortBookmarksRouting?
    private var clearDataRouter: ClearDataRouting?
    private var versionRouter: VersionRouting?
    
    init(interactor: SettingsInteractable,
         viewController: SettingsViewControllable,
         enableSharing: EnableSharingBuildable,
         appearance: AppearanceBuildable,
         sortBookmarks: SortBookmarksBuildable,
         clearData: ClearDataBuildable,
         version: VersionBuildable) {
        self.enableSharing = enableSharing
        self.appearance = appearance
        self.sortBookmarks = sortBookmarks
        self.clearData = clearData
        self.version = version
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    // MARK: - EnableSharing
    
    func attachEnableSharing() {
        guard enableSharingRouter == nil else { return }
        let router = enableSharing.build(withListener: interactor)
        enableSharingRouter = router
        attachChild(router)
        viewController.push(router.viewControllable)
    }
    
    func detachEnableSharing(includingView isViewIncluded: Bool) {
        guard let router = enableSharingRouter else { return }
        if isViewIncluded { viewController.pop() }
        detachChild(router)
        enableSharingRouter = nil
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
    
    // MARK: - Version
    
    func attachVersion(isLatestVersion: Bool, currentVersion: String) {
        guard versionRouter == nil else { return }
        let router = version.build(withListener: interactor, isLatestVersion: isLatestVersion, currentVersion: currentVersion)
        versionRouter = router
        attachChild(router)
        viewController.push(router.viewControllable)
    }
    
    func detachVersion(includingView isViewIncluded: Bool) {
        guard let router = versionRouter else { return }
        if isViewIncluded { viewController.pop() }
        detachChild(router)
        versionRouter = nil
    }
}
