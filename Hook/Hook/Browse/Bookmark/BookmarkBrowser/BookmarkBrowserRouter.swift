//
//  BookmarkBrowserRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs

protocol BookmarkBrowserInteractable: Interactable {
    var router: BookmarkBrowserRouting? { get set }
    var listener: BookmarkBrowserListener? { get set }
}

protocol BookmarkBrowserViewControllable: ViewControllable {}

final class BookmarkBrowserRouter: ViewableRouter<BookmarkBrowserInteractable, BookmarkBrowserViewControllable>, BookmarkBrowserRouting {
    
    override init(interactor: BookmarkBrowserInteractable, viewController: BookmarkBrowserViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
