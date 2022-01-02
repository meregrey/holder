//
//  SearchInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol SearchRouting: ViewableRouting {}

protocol SearchPresentable: Presentable {
    var listener: SearchPresentableListener? { get set }
}

protocol SearchListener: AnyObject {}

final class SearchInteractor: PresentableInteractor<SearchPresentable>, SearchInteractable, SearchPresentableListener {

    weak var router: SearchRouting?
    weak var listener: SearchListener?
    
    override init(presenter: SearchPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
    }
}
