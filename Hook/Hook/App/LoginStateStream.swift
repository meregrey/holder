//
//  LoginStateStream.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import RxRelay
import RxSwift

protocol LoginStateStreamType: AnyObject {
    var loginState: Observable<LoginState> { get }
}

protocol MutableLoginStateStreamType: LoginStateStreamType {
    func update(loginState: LoginState)
}

final class LoginStateStream: MutableLoginStateStreamType {
    
    private let relay = BehaviorRelay(value: LoginState.loggedOut)
    
    var loginState: Observable<LoginState> {
        return relay
            .asObservable()
            .distinctUntilChanged()
    }
    
    func update(loginState: LoginState) {
        relay.accept(loginState)
    }
}
