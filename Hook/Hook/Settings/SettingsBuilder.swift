//
//  SettingsBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsDependency: Dependency {}

final class SettingsComponent: Component<SettingsDependency> {}

// MARK: - Builder

protocol SettingsBuildable: Buildable {
    func build(withListener listener: SettingsListener) -> SettingsRouting
}

final class SettingsBuilder: Builder<SettingsDependency>, SettingsBuildable {
    
    override init(dependency: SettingsDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: SettingsListener) -> SettingsRouting {
        let viewController = SettingsViewController()
        let interactor = SettingsInteractor(presenter: viewController)
        interactor.listener = listener
        return SettingsRouter(interactor: interactor, viewController: viewController)
    }
}
