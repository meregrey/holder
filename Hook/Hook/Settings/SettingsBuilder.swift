//
//  SettingsBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsDependency: Dependency {
    var credential: Credential { get }
}

final class SettingsComponent: Component<SettingsDependency>, SettingsInteractorDependency, AppearanceDependency, SortBookmarksDependency {
    
    var credential: Credential { dependency.credential }
}

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
        let interactor = SettingsInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        let appearance = AppearanceBuilder(dependency: component)
        let sortBookmarks = SortBookmarksBuilder(dependency: component)
        return SettingsRouter(interactor: interactor,
                              viewController: viewController,
                              appearance: appearance,
                              sortBookmarks: sortBookmarks)
    }
}
