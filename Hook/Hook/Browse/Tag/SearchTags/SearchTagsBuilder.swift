//
//  SearchTagsBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/12.
//

import RIBs

protocol SearchTagsDependency: Dependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
    var tagBySearchStream: MutableStream<Tag> { get }
}

final class SearchTagsComponent: Component<SearchTagsDependency>, SearchTagsInteractorDependency {
    
    var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
    var tagBySearchStream: MutableStream<Tag> { dependency.tagBySearchStream }
}

// MARK: - Builder

protocol SearchTagsBuildable: Buildable {
    func build(withListener listener: SearchTagsListener) -> SearchTagsRouting
}

final class SearchTagsBuilder: Builder<SearchTagsDependency>, SearchTagsBuildable {
    
    override init(dependency: SearchTagsDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: SearchTagsListener) -> SearchTagsRouting {
        let component = SearchTagsComponent(dependency: dependency)
        let viewController = SearchTagsViewController(tags: component.tagsStream.value)
        let interactor = SearchTagsInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return SearchTagsRouter(interactor: interactor, viewController: viewController)
    }
}
