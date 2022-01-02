//
//  LoggedInInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import RIBs

protocol LoggedInRouting: ViewableRouting {}

protocol LoggedInPresentable: Presentable {
    var listener: LoggedInPresentableListener? { get set }
}

protocol LoggedInListener: AnyObject {}

final class LoggedInInteractor: PresentableInteractor<LoggedInPresentable>, LoggedInInteractable, LoggedInPresentableListener {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?
    
    override init(presenter: LoggedInPresentable) {
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
