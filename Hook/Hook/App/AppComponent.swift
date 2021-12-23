//
//  AppComponent.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import RIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {
    
    init() {
        super.init(dependency: EmptyComponent())
    }
}
