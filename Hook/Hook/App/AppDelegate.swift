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
    
    private var rootRouter: LaunchRouting?
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        adoptInterfaceStyle()
        launchRoot()
        return true
    }
    
    private func adoptInterfaceStyle() {
        guard let interfaceStyle = UserDefaults.value(forType: InterfaceStyle.self) else { return }
        window?.adoptInterfaceStyle(interfaceStyle)
    }
    
    private func launchRoot() {
        guard let window = window else { return }
        let root = RootBuilder(dependency: AppComponent()).build(withListener: self)
        rootRouter = root
        root.launch(from: window)
    }
}
