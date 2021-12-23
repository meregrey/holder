//
//  AppDelegate.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/21.
//

import RIBs
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let component = AppComponent()
    
    private var rootRouter: LaunchRouting?
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        launchRoot()
        return true
    }
    
    private func launchRoot() {
        guard let window = window else { return }
        let root = RootBuilder(dependency: component).build()
        rootRouter = root
        root.launch(from: window)
    }
}
