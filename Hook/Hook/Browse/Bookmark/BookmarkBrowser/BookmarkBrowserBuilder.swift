//
//  BookmarkBrowserBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs

protocol BookmarkBrowserDependency: Dependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
    var currentTagStream: MutableStream<Tag> { get }
}

final class BookmarkBrowserComponent: Component<BookmarkBrowserDependency>, BookmarkBrowserInteractorDependency {
    
    var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
    var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
}

// MARK: - Builder

protocol BookmarkBrowserBuildable: Buildable {
    func build(withListener listener: BookmarkBrowserListener) -> BookmarkBrowserRouting
}

final class BookmarkBrowserBuilder: Builder<BookmarkBrowserDependency>, BookmarkBrowserBuildable {
    
    override init(dependency: BookmarkBrowserDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: BookmarkBrowserListener) -> BookmarkBrowserRouting {
        let component = BookmarkBrowserComponent(dependency: dependency)
        let viewController = BookmarkBrowserViewController()
        let interactor = BookmarkBrowserInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return BookmarkBrowserRouter(interactor: interactor, viewController: viewController)
    }
}
