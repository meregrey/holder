//
//  RootInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs

protocol RootRouting: ViewableRouting {
    func attachTabs()
}

protocol RootPresentable: Presentable {
    var listener: RootPresentableListener? { get set }
}

protocol RootListener: AnyObject {}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener {
    
    weak var router: RootRouting?
    weak var listener: RootListener?
    
    private let userDefaults = UserDefaults(suiteName: UserDefaults.suiteName)
    
    private var observation: NSKeyValueObservation?
    
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    deinit {
        observation?.invalidate()
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        observeLastShareDate()
        router?.attachTabs()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    private func observeLastShareDate() {
        observation = userDefaults?.observe(\.lastShareDate, options: [.new]) { _, _ in
            NotificationCenter.post(named: NotificationName.lastShareDateDidChange)
        }
    }
}
