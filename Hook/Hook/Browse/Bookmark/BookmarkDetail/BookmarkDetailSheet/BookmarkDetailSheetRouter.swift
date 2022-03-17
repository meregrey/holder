//
//  BookmarkDetailSheetRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/16.
//

import RIBs

protocol BookmarkDetailSheetInteractable: Interactable {
    var router: BookmarkDetailSheetRouting? { get set }
    var listener: BookmarkDetailSheetListener? { get set }
}

protocol BookmarkDetailSheetViewControllable: ViewControllable {}

final class BookmarkDetailSheetRouter: ViewableRouter<BookmarkDetailSheetInteractable, BookmarkDetailSheetViewControllable>, BookmarkDetailSheetRouting {
    
    override init(interactor: BookmarkDetailSheetInteractable, viewController: BookmarkDetailSheetViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
