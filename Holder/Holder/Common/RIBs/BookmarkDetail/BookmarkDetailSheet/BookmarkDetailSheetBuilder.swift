//
//  BookmarkDetailSheetBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/16.
//

import RIBs

protocol BookmarkDetailSheetDependency: Dependency {}

final class BookmarkDetailSheetComponent: Component<BookmarkDetailSheetDependency> {}

// MARK: - Builder

protocol BookmarkDetailSheetBuildable: Buildable {
    func build(withListener listener: BookmarkDetailSheetListener) -> BookmarkDetailSheetRouting
}

final class BookmarkDetailSheetBuilder: Builder<BookmarkDetailSheetDependency>, BookmarkDetailSheetBuildable {
    
    override init(dependency: BookmarkDetailSheetDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: BookmarkDetailSheetListener) -> BookmarkDetailSheetRouting {
        let viewController = BookmarkDetailSheetViewController()
        let interactor = BookmarkDetailSheetInteractor(presenter: viewController)
        interactor.listener = listener
        return BookmarkDetailSheetRouter(interactor: interactor, viewController: viewController)
    }
}
