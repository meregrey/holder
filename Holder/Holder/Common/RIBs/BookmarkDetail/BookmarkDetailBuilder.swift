//
//  BookmarkDetailBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/11.
//

import RIBs

protocol BookmarkDetailDependency: Dependency {}

final class BookmarkDetailComponent: Component<BookmarkDetailDependency>, BookmarkDetailInteractorDependency, BookmarkDetailSheetDependency {
    
    let bookmark: Bookmark
    
    init(dependency: BookmarkDetailDependency, bookmark: Bookmark) {
        self.bookmark = bookmark
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol BookmarkDetailBuildable: Buildable {
    func build(withListener listener: BookmarkDetailListener, bookmark: Bookmark) -> BookmarkDetailRouting
}

final class BookmarkDetailBuilder: Builder<BookmarkDetailDependency>, BookmarkDetailBuildable {
    
    override init(dependency: BookmarkDetailDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: BookmarkDetailListener, bookmark: Bookmark) -> BookmarkDetailRouting {
        let component = BookmarkDetailComponent(dependency: dependency, bookmark: bookmark)
        let viewController = BookmarkDetailViewController()
        let interactor = BookmarkDetailInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        let bookmarkDetailSheet = BookmarkDetailSheetBuilder(dependency: component)
        return BookmarkDetailRouter(interactor: interactor,
                                    viewController: viewController,
                                    bookmarkDetailSheet: bookmarkDetailSheet)
    }
}
