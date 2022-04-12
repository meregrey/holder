//
//  TagSettingsBuilder.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import RIBs

protocol TagSettingsDependency: Dependency {}

final class TagSettingsComponent: Component<TagSettingsDependency> {}

// MARK: - Builder

protocol TagSettingsBuildable: Buildable {
    func build(withListener listener: TagSettingsListener) -> TagSettingsRouting
}

final class TagSettingsBuilder: Builder<TagSettingsDependency>, TagSettingsBuildable {
    
    override init(dependency: TagSettingsDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: TagSettingsListener) -> TagSettingsRouting {
        let viewController = TagSettingsViewController()
        let interactor = TagSettingsInteractor(presenter: viewController)
        interactor.listener = listener
        return TagSettingsRouter(interactor: interactor, viewController: viewController)
    }
}
