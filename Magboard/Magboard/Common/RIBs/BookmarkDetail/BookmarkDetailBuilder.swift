//
//  BookmarkDetailBuilder.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/11.
//

import RIBs

protocol BookmarkDetailDependency: Dependency {}

final class BookmarkDetailComponent: Component<BookmarkDetailDependency>, BookmarkDetailInteractorDependency, BookmarkDetailSheetDependency {
    
    let bookmarkEntity: BookmarkEntity
    
    init(dependency: BookmarkDetailDependency, bookmarkEntity: BookmarkEntity) {
        self.bookmarkEntity = bookmarkEntity
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol BookmarkDetailBuildable: Buildable {
    func build(withListener listener: BookmarkDetailListener, bookmarkEntity: BookmarkEntity) -> BookmarkDetailRouting
}

final class BookmarkDetailBuilder: Builder<BookmarkDetailDependency>, BookmarkDetailBuildable {
    
    override init(dependency: BookmarkDetailDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: BookmarkDetailListener, bookmarkEntity: BookmarkEntity) -> BookmarkDetailRouting {
        let component = BookmarkDetailComponent(dependency: dependency, bookmarkEntity: bookmarkEntity)
        let viewController = BookmarkDetailViewController()
        let interactor = BookmarkDetailInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        let bookmarkDetailSheet = BookmarkDetailSheetBuilder(dependency: component)
        return BookmarkDetailRouter(interactor: interactor,
                                    viewController: viewController,
                                    bookmarkDetailSheet: bookmarkDetailSheet)
    }
}
