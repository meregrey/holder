//
//  ShareExtensionComponent.swift
//  ShareExtension
//
//  Created by Yeojin Yoon on 2022/04/20.
//

import RIBs

final class ShareExtensionComponent: Component<EmptyDependency>, ShareDependency {
    
    var baseViewController: ShareViewControllable
    
    init(baseViewController: ShareViewControllable) {
        self.baseViewController = baseViewController
        super.init(dependency: EmptyComponent())
    }
}
