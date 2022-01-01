//
//  AppDelegate.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import RIBs
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, RootListener {
    
    private let component: AppComponent
    
    private var credentialRepository: CredentialRepositoryType { component.credentialRepository }
    private var rootRouter: LaunchRouting?
    
    var window: UIWindow?
    
    private override init() {
        self.component = AppComponent()
    }
    
    init(component: AppComponent) {
        self.component = component
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        verifyLoginState()
        launchRoot()
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        verifyLoginState()
    }
    
    func didSucceedLogin(withCredential credential: Credential) {
        let result = credentialRepository.save(credential: credential)
        switch result {
        case .success(()): break
        case .failure(_): postNotification(ofName: NotificationName.didFailToSaveCredential)
        }
    }
    
    func didRequestLogout() {
        credentialRepository.delete()
    }
    
    private func verifyLoginState() {
        credentialRepository.verify()
    }
    
    private func launchRoot() {
        guard let window = window else { return }
        let root = RootBuilder(dependency: component).build(withListener: self)
        rootRouter = root
        root.launch(from: window)
    }
    
    private func postNotification(ofName name: NSNotification.Name) {
        NotificationCenter.default.post(name: name, object: nil)
    }
}
