//
//  TagInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs
import RxSwift

protocol TagRouting: Routing {
    func attachTagBar()
    func cleanupViews()
}

protocol TagListener: AnyObject {}

protocol TagInteractorDependency {
    var tagRepository: TagRepositoryType { get }
}

final class TagInteractor: Interactor, TagInteractable {
    
    private let dependency: TagInteractorDependency
    
    private var tagRepository: TagRepositoryType { dependency.tagRepository }
    
    weak var router: TagRouting?
    weak var listener: TagListener?
    
    init(dependency: TagInteractorDependency) {
        self.dependency = dependency
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTagBar()
    }
    
    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
}
