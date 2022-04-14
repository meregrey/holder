//
//  AppearanceInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import RIBs

protocol AppearanceRouting: ViewableRouting {}

protocol AppearancePresentable: Presentable {
    var listener: AppearancePresentableListener? { get set }
}

protocol AppearanceListener: AnyObject {
    func appearanceBackButtonDidTap()
    func appearanceDidRemove()
}

final class AppearanceInteractor: PresentableInteractor<AppearancePresentable>, AppearanceInteractable, AppearancePresentableListener {
    
    weak var router: AppearanceRouting?
    weak var listener: AppearanceListener?
    
    override init(presenter: AppearancePresentable) {
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
        listener?.appearanceBackButtonDidTap()
    }
    
    func didRemove() {
        listener?.appearanceDidRemove()
    }
}
