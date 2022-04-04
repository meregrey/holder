//
//  SettingsInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs

protocol SettingsRouting: ViewableRouting {}

protocol SettingsPresentable: Presentable {
    var listener: SettingsPresentableListener? { get set }
    func update(with credential: Credential)
}

protocol SettingsListener: AnyObject {}

protocol SettingsInteractorDependency {
    var credential: Credential { get }
}

final class SettingsInteractor: PresentableInteractor<SettingsPresentable>, SettingsInteractable, SettingsPresentableListener {
    
    private let dependency: SettingsInteractorDependency
    
    private var credential: Credential { dependency.credential }
    
    weak var router: SettingsRouting?
    weak var listener: SettingsListener?
    
    init(presenter: SettingsPresentable, dependency: SettingsInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        presenter.update(with: credential)
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
}
