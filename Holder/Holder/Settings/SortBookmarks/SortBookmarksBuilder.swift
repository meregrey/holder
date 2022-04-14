//
//  SortBookmarksBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import RIBs

protocol SortBookmarksDependency: Dependency {}

final class SortBookmarksComponent: Component<SortBookmarksDependency> {}

// MARK: - Builder

protocol SortBookmarksBuildable: Buildable {
    func build(withListener listener: SortBookmarksListener) -> SortBookmarksRouting
}

final class SortBookmarksBuilder: Builder<SortBookmarksDependency>, SortBookmarksBuildable {
    
    override init(dependency: SortBookmarksDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: SortBookmarksListener) -> SortBookmarksRouting {
        let viewController = SortBookmarksViewController()
        let interactor = SortBookmarksInteractor(presenter: viewController)
        interactor.listener = listener
        return SortBookmarksRouter(interactor: interactor, viewController: viewController)
    }
}
