//
//  LoggedInInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import RIBs
import RxSwift

protocol LoggedInRouting: Routing {
    func cleanupViews()
}

protocol LoggedInListener: AnyObject {}

final class LoggedInInteractor: Interactor, LoggedInInteractable {

    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?
    
    override init() {}

    override func didBecomeActive() {
        super.didBecomeActive()
    }

    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
}
