//
//  BookmarkListBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/23.
//

import RIBs

protocol BookmarkListDependency: Dependency {
    var searchTermStream: MutableStream<String> { get }
    var isForFavorites: Bool { get }
}

final class BookmarkListComponent: Component<BookmarkListDependency>, BookmarkListInteractorDependency, BookmarkDetailDependency {
    
    var searchTermStream: ReadOnlyStream<String> { dependency.searchTermStream }
    var isForFavorites: Bool { dependency.isForFavorites }
}

// MARK: - Builder

protocol BookmarkListBuildable: Buildable {
    func build(withListener listener: BookmarkListListener, forFavorites isForFavorites: Bool) -> BookmarkListRouting
}

final class BookmarkListBuilder: Builder<BookmarkListDependency>, BookmarkListBuildable {
    
    override init(dependency: BookmarkListDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: BookmarkListListener, forFavorites isForFavorites: Bool) -> BookmarkListRouting {
        let component = BookmarkListComponent(dependency: dependency)
        let viewController = BookmarkListViewController(forFavorites: isForFavorites)
        let interactor = BookmarkListInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return BookmarkListRouter(interactor: interactor, viewController: viewController)
    }
}
