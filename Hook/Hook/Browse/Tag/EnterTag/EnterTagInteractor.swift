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
    func enterTagSaveButtonDidTap(mode: EnterTagMode, tag: Tag)
}

protocol EnterTagInteractorDependency {
    var mode: EnterTagMode { get }
}

final class EnterTagInteractor: PresentableInteractor<EnterTagPresentable>, EnterTagInteractable, EnterTagPresentableListener {
    
    private let dependency: EnterTagInteractorDependency
    
    private var mode: EnterTagMode { dependency.mode }
    
    weak var router: EnterTagRouting?
    weak var listener: EnterTagListener?
    
    init(presenter: EnterTagPresentable, dependency: EnterTagInteractorDependency) {
        self.dependency = dependency
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
    
    func saveButtonDidTap(tag: Tag) {
        listener?.enterTagSaveButtonDidTap(mode: mode, tag: tag)
    }
}
