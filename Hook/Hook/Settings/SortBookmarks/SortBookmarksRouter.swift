//
//  SortBookmarksRouter.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import RIBs

protocol SortBookmarksInteractable: Interactable {
    var router: SortBookmarksRouting? { get set }
    var listener: SortBookmarksListener? { get set }
}

protocol SortBookmarksViewControllable: ViewControllable {}

final class SortBookmarksRouter: ViewableRouter<SortBookmarksInteractable, SortBookmarksViewControllable>, SortBookmarksRouting {
    
    override init(interactor: SortBookmarksInteractable, viewController: SortBookmarksViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
