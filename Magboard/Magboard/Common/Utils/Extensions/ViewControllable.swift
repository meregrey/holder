//
//  ViewControllable.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import RIBs
import UIKit

extension ViewControllable {
    func present(_ viewControllableToPresent: ViewControllable,
                 modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                 animated: Bool = false,
                 completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            viewControllableToPresent.uiviewController.modalPresentationStyle = modalPresentationStyle
            self.uiviewController.present(viewControllableToPresent.uiviewController,
                                          animated: animated,
                                          completion: completion)
        }
    }
    
    func dismiss(animated: Bool = false, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.uiviewController.dismiss(animated: animated, completion: completion)
        }
    }
    
    func presentAlert(title: String, message: String? = nil, action: Action? = nil) {
        DispatchQueue.main.async {
            let alertController = AlertController(title: title, message: message, action: action)
            self.uiviewController.present(alertController, animated: true)
        }
    }
}
