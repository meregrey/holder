//
//  AppDelegate.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import AuthenticationServices
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let component = AppComponent(credentialRepository: CredentialRepository(keychainManager: KeychainManager()))
    
    private var credentialRepository: CredentialRepositoryType { component.credentialRepository }
    private var mutableLoginStateStream: MutableLoginStateStreamType { component.mutableLoginStateStream }
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        validateCredential()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        validateCredential()
    }
    
    private func validateCredential() {
        switch credentialRepository.fetch() {
        case .success(let credential):
            guard let credential = credential else {
                mutableLoginStateStream.update(loginState: .loggedOut)
                return
            }
            authenticateCredential(credential)
        case .failure(let error):
            mutableLoginStateStream.update(loginState: .loggedOut)
            NotificationCenter.default.post(name: NotificationName.credentialErrorDidOccur,
                                            object: nil,
                                            userInfo: [NotificationUserInfoKey.error: error])
        }
    }
    
    private func authenticateCredential(_ credential: Credential) {
        ASAuthorizationAppleIDProvider().getCredentialState(forUserID: credential.identifier) { credentialState, _ in
            switch credentialState {
            case .authorized:
                self.mutableLoginStateStream.update(loginState: .loggedIn(credential: credential))
            default:
                self.deleteCredential()
                self.mutableLoginStateStream.update(loginState: .loggedOut)
            }
        }
    }
    
    private func deleteCredential() {
        switch credentialRepository.delete() {
        case .success(()):
            break
        case .failure(let error):
            NotificationCenter.default.post(name: NotificationName.credentialErrorDidOccur,
                                            object: nil,
                                            userInfo: [NotificationUserInfoKey.error: error])
        }
    }
}
