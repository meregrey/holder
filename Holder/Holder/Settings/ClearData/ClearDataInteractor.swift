//
//  ClearDataInteractor.swift
//  Holder
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
    func clearDataClearButtonDidTap()
    func clearDataDidRemove()
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
    
    func clearButtonDidTap() {
        TagRepository.shared.clear()
        BookmarkRepository.shared.clear()
        listener?.clearDataClearButtonDidTap()
    }
    
    func didRemove() {
        listener?.clearDataDidRemove()
    }
}
