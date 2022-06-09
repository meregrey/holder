//
//  SettingsInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsRouting: ViewableRouting {
    func attachEnableSharing()
    func detachEnableSharing(includingView isViewIncluded: Bool)
    func attachAppearance()
    func detachAppearance(includingView isViewIncluded: Bool)
    func attachSortBookmarks()
    func detachSortBookmarks(includingView isViewIncluded: Bool)
    func attachClearData()
    func detachClearData(includingView isViewIncluded: Bool)
    func attachVersion(isLatestVersion: Bool, currentVersion: String)
    func detachVersion(includingView isViewIncluded: Bool)
}

protocol SettingsPresentable: Presentable {
    var listener: SettingsPresentableListener? { get set }
    func update(with isLatestVersion: Bool)
}

protocol SettingsListener: AnyObject {}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>, SettingsInteractable, SettingsPresentableListener {
    
    weak var router: SettingsRouting?
    weak var listener: SettingsListener?
    
    private let currentVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    
    private var isLatestVersion = false
    
    override init(presenter: SettingsPresentable) {
        super.init(presenter: presenter)
        checkLatestVersion()
        presenter.listener = self
        presenter.update(with: isLatestVersion)
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func enableSharingOptionViewDidTap() {
        router?.attachEnableSharing()
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
    
    func versionOptionViewDidTap() {
        guard let currentVersion = currentVersion else { return }
        router?.attachVersion(isLatestVersion: isLatestVersion, currentVersion: currentVersion)
    }
    
    private func checkLatestVersion() {
        guard let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.yeojin-yoon.holder") else { return }
        guard let data = try? Data(contentsOf: url) else { return }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any] else { return }
        guard let results = json["results"] as? [[String: Any]], results.count > 0 else { return }
        guard let releaseVersion = results.first?["version"] as? String else { return }
        isLatestVersion = currentVersion == releaseVersion
    }
    
    // MARK: - EnableSharing
    
    func enableSharingBackButtonDidTap() {
        router?.detachEnableSharing(includingView: true)
    }
    
    func enableSharingDidRemove() {
        router?.detachEnableSharing(includingView: false)
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
    
    func clearDataClearButtonDidTap() {
        router?.detachClearData(includingView: true)
    }
    
    func clearDataDidRemove() {
        router?.detachClearData(includingView: false)
    }
    
    // MARK: - Version
    
    func versionBackButtonDidTap() {
        router?.detachVersion(includingView: true)
    }
    
    func versionOpenAppStoreButtonDidTap() {
        router?.detachVersion(includingView: true)
    }
    
    func versionDidRemove() {
        router?.detachVersion(includingView: false)
    }
}
