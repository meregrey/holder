//
//  ViewControllable.swift
//  Hook
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
        viewControllableToPresent.uiviewController.modalPresentationStyle = modalPresentationStyle
        uiviewController.present(viewControllableToPresent.uiviewController,
                                 animated: animated,
                                 completion: completion)
    }
    
    func dismiss(animated: Bool = false, completion: (() -> Void)? = nil) {
        uiviewController.dismiss(animated: animated, completion: completion)
    }
    
    func presentAlert(withTitle title: String, message: String, action: [UIAlertAction]? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = action ?? [UIAlertAction(title: LocalizedString.AlertActionTitle.ok, style: .default)]
        action.forEach { alert.addAction($0) }
        uiviewController.present(alert, animated: true)
    }
}
