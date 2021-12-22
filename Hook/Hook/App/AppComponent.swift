//
//  AppComponent.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import RIBs

final class AppComponent: Component<EmptyDependency> {
    
    let credentialRepository: CredentialRepositoryType
    
    var mutableLoginStateStream: MutableLoginStateStreamType { shared { LoginStateStream() } }
    var loginStateStream: LoginStateStreamType { mutableLoginStateStream }
    
    init(credentialRepository: CredentialRepositoryType) {
        self.credentialRepository = credentialRepository
        super.init(dependency: EmptyComponent())
    }
}
