//
//  TagSettingsBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import RIBs

protocol TagSettingsDependency: Dependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
}

final class TagSettingsComponent: Component<TagSettingsDependency>, TagSettingsInteractorDependency {
    
    var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
}

// MARK: - Builder

protocol TagSettingsBuildable: Buildable {
    func build(withListener listener: TagSettingsListener) -> TagSettingsRouting
}

final class TagSettingsBuilder: Builder<TagSettingsDependency>, TagSettingsBuildable {
    
    override init(dependency: TagSettingsDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: TagSettingsListener) -> TagSettingsRouting {
        let component = TagSettingsComponent(dependency: dependency)
        let viewController = TagSettingsViewController()
        let interactor = TagSettingsInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TagSettingsRouter(interactor: interactor, viewController: viewController)
    }
}
