//
//  AppComponent.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import RIBs

final class AppComponent: Component<EmptyDependency>, RootDependency {
    
    let credentialRepository: CredentialRepositoryType
    
    var loginStateStream: Stream<LoginState> { credentialRepository.loginStateStream }
    
    init(credentialRepository: CredentialRepositoryType = CredentialRepository()) {
        self.credentialRepository = credentialRepository
        super.init(dependency: EmptyComponent())
    }
}
