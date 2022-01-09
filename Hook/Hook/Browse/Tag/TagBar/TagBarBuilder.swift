//
//  TagBarBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs

protocol TagBarDependency: Dependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
}

final class TagBarComponent: Component<TagBarDependency>, TagBarInteractorDependency {
    
    var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
}

// MARK: - Builder

protocol TagBarBuildable: Buildable {
    func build(withListener listener: TagBarListener) -> TagBarRouting
}

final class TagBarBuilder: Builder<TagBarDependency>, TagBarBuildable {

    override init(dependency: TagBarDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: TagBarListener) -> TagBarRouting {
        let component = TagBarComponent(dependency: dependency)
        let viewController = TagBarViewController()
        let interactor = TagBarInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return TagBarRouter(interactor: interactor, viewController: viewController)
    }
}
