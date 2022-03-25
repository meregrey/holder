//
//  SelectTagsBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/04.
//

import RIBs

protocol SelectTagsDependency: Dependency {
    var tagBySearchStream: MutableStream<Tag> { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class SelectTagsComponent: Component<SelectTagsDependency>, SelectTagsInteractorDependency {
    
    let existingSelectedTags: [Tag]
    
    var tagBySearchStream: MutableStream<Tag> { dependency.tagBySearchStream }
    var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
    init(dependency: SelectTagsDependency, existingSelectedTags: [Tag]) {
        self.existingSelectedTags = existingSelectedTags
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol SelectTagsBuildable: Buildable {
    func build(withListener listener: SelectTagsListener, existingSelectedTags: [Tag]) -> SelectTagsRouting
}

final class SelectTagsBuilder: Builder<SelectTagsDependency>, SelectTagsBuildable {
    
    override init(dependency: SelectTagsDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: SelectTagsListener, existingSelectedTags: [Tag]) -> SelectTagsRouting {
        let component = SelectTagsComponent(dependency: dependency, existingSelectedTags: existingSelectedTags)
        let viewController = SelectTagsViewController()
        let interactor = SelectTagsInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SelectTagsRouter(interactor: interactor, viewController: viewController)
    }
}
