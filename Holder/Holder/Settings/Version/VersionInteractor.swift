//
//  VersionInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/06/08.
//

import RIBs

protocol VersionRouting: ViewableRouting {}

protocol VersionPresentable: Presentable {
    var listener: VersionPresentableListener? { get set }
}

protocol VersionListener: AnyObject {
    func versionBackButtonDidTap()
    func versionOpenAppStoreButtonDidTap()
    func versionDidRemove()
}

final class VersionInteractor: PresentableInteractor<VersionPresentable>, VersionInteractable, VersionPresentableListener {
    
    weak var router: VersionRouting?
    weak var listener: VersionListener?
    
    private let appStoreLink = "itms-apps://itunes.apple.com/app/1625219971"
    
    override init(presenter: VersionPresentable) {
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
        listener?.versionBackButtonDidTap()
    }
    
    func openAppStoreButtonDidTap() {
        guard let url = URL(string: appStoreLink) else { return }
        UIApplication.shared.open(url)
        listener?.versionOpenAppStoreButtonDidTap()
    }
    
    func didRemove() {
        listener?.versionDidRemove()
    }
}
