//
//  BookmarkDetailRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/11.
//

import RIBs

protocol BookmarkDetailInteractable: Interactable {
    var router: BookmarkDetailRouting? { get set }
    var listener: BookmarkDetailListener? { get set }
}

protocol BookmarkDetailViewControllable: ViewControllable {}

final class BookmarkDetailRouter: ViewableRouter<BookmarkDetailInteractable, BookmarkDetailViewControllable>, BookmarkDetailRouting {
    
    override init(interactor: BookmarkDetailInteractable, viewController: BookmarkDetailViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
