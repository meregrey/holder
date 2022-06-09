//
//  SettingsBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsDependency: Dependency {}

final class SettingsComponent: Component<SettingsDependency>, EnableSharingDependency, AppearanceDependency, SortBookmarksDependency, ClearDataDependency, VersionDependency {}

// MARK: - Builder

protocol SettingsBuildable: Buildable {
    func build(withListener listener: SettingsListener) -> SettingsRouting
}

final class SettingsBuilder: Builder<SettingsDependency>, SettingsBuildable {
    
    override init(dependency: SettingsDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: SettingsListener) -> SettingsRouting {
        let component = SettingsComponent(dependency: dependency)
        let viewController = SettingsViewController()
        let interactor = SettingsInteractor(presenter: viewController)
        interactor.listener = listener
        let enableSharing = EnableSharingBuilder(dependency: component)
        let appearance = AppearanceBuilder(dependency: component)
        let sortBookmarks = SortBookmarksBuilder(dependency: component)
        let clearData = ClearDataBuilder(dependency: component)
        let version = VersionBuilder(dependency: component)
        return SettingsRouter(interactor: interactor,
                              viewController: viewController,
                              enableSharing: enableSharing,
                              appearance: appearance,
                              sortBookmarks: sortBookmarks,
                              clearData: clearData,
                              version: version)
    }
}
