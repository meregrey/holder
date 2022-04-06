//
//  ClearDataInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/04/06.
//

import RIBs

protocol ClearDataRouting: ViewableRouting {}

protocol ClearDataPresentable: Presentable {
    var listener: ClearDataPresentableListener? { get set }
}

protocol ClearDataListener: AnyObject {
    func clearDataBackButtonDidTap()
    func clearDataDidRemove()
    func clearDataClearButtonDidTap()
}

final class ClearDataInteractor: PresentableInteractor<ClearDataPresentable>, ClearDataInteractable, ClearDataPresentableListener {
    
    weak var router: ClearDataRouting?
    weak var listener: ClearDataListener?
    
    override init(presenter: ClearDataPresentable) {
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
        listener?.clearDataBackButtonDidTap()
    }
    
    func didRemove() {
        listener?.clearDataDidRemove()
    }
    
    func clearButtonDidTap() {
        TagRepository.shared.clear()
        BookmarkRepository.shared.clear()
        listener?.clearDataClearButtonDidTap()
    }
}
