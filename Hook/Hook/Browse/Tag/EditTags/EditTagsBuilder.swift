//
//  EditTagsBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/15.
//

import RIBs

protocol EditTagsDependency: Dependency {}

final class EditTagsComponent: Component<EditTagsDependency> {}

// MARK: - Builder

protocol EditTagsBuildable: Buildable {
    func build(withListener listener: EditTagsListener) -> EditTagsRouting
}

final class EditTagsBuilder: Builder<EditTagsDependency>, EditTagsBuildable {
    
    override init(dependency: EditTagsDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EditTagsListener) -> EditTagsRouting {
        let viewController = EditTagsViewController()
        let interactor = EditTagsInteractor(presenter: viewController)
        interactor.listener = listener
        return EditTagsRouter(interactor: interactor, viewController: viewController)
    }
}
