//
//  BookmarkListRouter.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/03/23.
//

import RIBs

protocol BookmarkListInteractable: Interactable {
    var router: BookmarkListRouting? { get set }
    var listener: BookmarkListListener? { get set }
}

protocol BookmarkListViewControllable: ViewControllable {}

final class BookmarkListRouter: ViewableRouter<BookmarkListInteractable, BookmarkListViewControllable>, BookmarkListRouting {
    
    override init(interactor: BookmarkListInteractable, viewController: BookmarkListViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
