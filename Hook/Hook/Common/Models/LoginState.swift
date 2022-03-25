//
//  LoginState.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import Foundation

enum LoginState: Equatable {
    case loggedOut
    case loggedIn(credential: Credential)
    
    static func == (lhs: LoginState, rhs: LoginState) -> Bool {
        switch (lhs, rhs) {
        case (.loggedOut, .loggedOut):
            return true
        case (.loggedIn(let lhsCredential), .loggedIn(let rhsCredential)):
            return lhsCredential.identifier == rhsCredential.identifier && lhsCredential.name == rhsCredential.name
        default:
            return false
        }
    }
}
