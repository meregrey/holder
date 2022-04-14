//
//  AppComponent.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/04/05.
//

import RIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {
    
    init() {
        super.init(dependency: EmptyComponent())
    }
}
