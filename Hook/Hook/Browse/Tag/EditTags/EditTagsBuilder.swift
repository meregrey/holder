//
//  EditTagsBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/15.
//

import RIBs

protocol EditTagsDependency: Dependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
}

final class EditTagsComponent: Component<EditTagsDependency>, EditTagsInteractorDependency {
    
    var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
}

// MARK: - Builder

protocol EditTagsBuildable: Buildable {
    func build(withListener listener: EditTagsListener) -> EditTagsRouting
}

final class EditTagsBuilder: Builder<EditTagsDependency>, EditTagsBuildable {
    
    override init(dependency: EditTagsDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EditTagsListener) -> EditTagsRouting {
        let component = EditTagsComponent(dependency: dependency)
        let viewController = EditTagsViewController()
        let interactor = EditTagsInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return EditTagsRouter(interactor: interactor, viewController: viewController)
    }
}
