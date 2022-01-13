//
//  EnterTagInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/12.
//

import RIBs

protocol EnterTagRouting: ViewableRouting {}

protocol EnterTagPresentable: Presentable {
    var listener: EnterTagPresentableListener? { get set }
}

protocol EnterTagListener: AnyObject {
    func enterTagBackButtonDidTap()
    func enterTagSaveButtonDidTap(with tag: Tag)
}

final class EnterTagInteractor: PresentableInteractor<EnterTagPresentable>, EnterTagInteractable, EnterTagPresentableListener {
    
    weak var router: EnterTagRouting?
    weak var listener: EnterTagListener?
    
    override init(presenter: EnterTagPresentable) {
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
        listener?.enterTagBackButtonDidTap()
    }
    
    func saveButtonDidTap(with tag: Tag) {
        listener?.enterTagSaveButtonDidTap(with: tag)
    }
}
