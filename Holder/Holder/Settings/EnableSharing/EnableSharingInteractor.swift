//
//  EnableSharingInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/06/09.
//

import RIBs

protocol EnableSharingRouting: ViewableRouting {}

protocol EnableSharingPresentable: Presentable {
    var listener: EnableSharingPresentableListener? { get set }
}

protocol EnableSharingListener: AnyObject {
    func enableSharingBackButtonDidTap()
    func enableSharingDidRemove()
}

final class EnableSharingInteractor: PresentableInteractor<EnableSharingPresentable>, EnableSharingInteractable, EnableSharingPresentableListener {
    
    weak var router: EnableSharingRouting?
    weak var listener: EnableSharingListener?
    
    override init(presenter: EnableSharingPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func backButtonDidTap() {
        listener?.enableSharingBackButtonDidTap()
    }
    
    func didRemove() {
        listener?.enableSharingDidRemove()
    }
}
