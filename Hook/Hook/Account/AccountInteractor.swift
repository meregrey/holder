//
//  AccountInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol AccountRouting: ViewableRouting {}

protocol AccountPresentable: Presentable {
    var listener: AccountPresentableListener? { get set }
}

protocol AccountListener: AnyObject {}

final class AccountInteractor: PresentableInteractor<AccountPresentable>, AccountInteractable, AccountPresentableListener {

    weak var router: AccountRouting?
    weak var listener: AccountListener?
    
    override init(presenter: AccountPresentable) {
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
