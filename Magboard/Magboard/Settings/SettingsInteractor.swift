//
//  SettingsInteractor.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsRouting: ViewableRouting {
    func attachAppearance()
    func detachAppearance(includingView isViewIncluded: Bool)
    func attachSortBookmarks()
    func detachSortBookmarks(includingView isViewIncluded: Bool)
    func attachClearData()
    func detachClearData(includingView isViewIncluded: Bool)
}

protocol SettingsPresentable: Presentable {
    var listener: SettingsPresentableListener? { get set }
}

protocol SettingsListener: AnyObject {}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>, SettingsInteractable, SettingsPresentableListener {
    
    weak var router: SettingsRouting?
    weak var listener: SettingsListener?
    
    override init(presenter: SettingsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
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
    
    func clearDataOptionViewDidTap() {
        router?.attachClearData()
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
    
    // MARK: - ClearData
    
    func clearDataBackButtonDidTap() {
        router?.detachClearData(includingView: true)
    }
    
    func clearDataDidRemove() {
        router?.detachClearData(includingView: false)
    }
    
    func clearDataClearButtonDidTap() {
        router?.detachClearData(includingView: true)
    }
}
