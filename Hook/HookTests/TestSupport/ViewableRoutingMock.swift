//
//  ViewableRoutingMock.swift
//  HookTests
//
//  Created by Yeojin Yoon on 2021/12/31.
//

import RIBs
import RxSwift

class ViewableRoutingMock: ViewableRouting {
    
    var viewControllable: ViewControllable = ViewControllableMock()
    var interactable: Interactable = Interactor()
    var children: [Routing] = .init()
    var lifecycleSubject: PublishSubject<RouterLifecycle> = .init()
    var lifecycle: Observable<RouterLifecycle> { lifecycleSubject }
    
    var loadCallCount = 0
    var loadHandler: (() -> Void)?
    var attachChildCallCount = 0
    var attachChildHandler: ((_ child: Routing) -> Void)?
    var detachChildCallCount = 0
    var detachChildHandler: ((_ child: Routing) -> Void)?
    
    func load() {
        loadCallCount += 1
        if let loadHandler = loadHandler { return loadHandler() }
    }
    
    func attachChild(_ child: Routing) {
        attachChildCallCount += 1
        if let attachChildHandler = attachChildHandler { return attachChildHandler(child) }
    }
    
    func detachChild(_ child: Routing) {
        detachChildCallCount += 1
        if let detachChildHandler = detachChildHandler { return detachChildHandler(child) }
    }
}
