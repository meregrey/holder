//
//  BookmarkBrowserBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs

protocol BookmarkBrowserDependency: Dependency {}

final class BookmarkBrowserComponent: Component<BookmarkBrowserDependency> {}

// MARK: - Builder

protocol BookmarkBrowserBuildable: Buildable {
    func build(withListener listener: BookmarkBrowserListener) -> BookmarkBrowserRouting
}

final class BookmarkBrowserBuilder: Builder<BookmarkBrowserDependency>, BookmarkBrowserBuildable {
    
    override init(dependency: BookmarkBrowserDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: BookmarkBrowserListener) -> BookmarkBrowserRouting {
        let viewController = BookmarkBrowserViewController()
        let interactor = BookmarkBrowserInteractor(presenter: viewController)
        interactor.listener = listener
        return BookmarkBrowserRouter(interactor: interactor, viewController: viewController)
    }
}
