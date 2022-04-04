//
//  SettingsInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsRouting: ViewableRouting {
    func attachAppearance()
    func detachAppearance(includingView isViewIncluded: Bool)
    func attachSortBookmarks()
    func detachSortBookmarks(includingView isViewIncluded: Bool)
}

protocol SettingsPresentable: Presentable {
    var listener: SettingsPresentableListener? { get set }
    func update(with credential: Credential)
}

protocol SettingsListener: AnyObject {}

protocol SettingsInteractorDependency {
    var credential: Credential { get }
}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>, SettingsInteractable, SettingsPresentableListener {
    
    private let dependency: SettingsInteractorDependency
    
    private var credential: Credential { dependency.credential }
    
    weak var router: SettingsRouting?
    weak var listener: SettingsListener?
    
    init(presenter: SettingsPresentable, dependency: SettingsInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.update(with: credential)
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func appearanceOptionViewDidTap() {
        router?.attachAppearance()
    }
    
    func sortBookmarksOptionViewDidTap() {
        router?.attachSortBookmarks()
    }
    
    // MARK: - Appearance
    
    func appearanceBackButtonDidTap() {
        router?.detachAppearance(includingView: true)
    }
    
    func appearanceDidRemove() {
        router?.detachAppearance(includingView: false)
    }
    
    // MARK: - SortBookmarks
    
    func sortBookmarksBackButtonDidTap() {
        router?.detachSortBookmarks(includingView: true)
    }
    
    func sortBookmarksDidRemove() {
        router?.detachSortBookmarks(includingView: false)
    }
}
