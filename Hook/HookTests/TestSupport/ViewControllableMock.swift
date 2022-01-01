//
//  ViewControllableMock.swift
//  HookTests
//
//  Created by Yeojin Yoon on 2021/12/31.
//

import RIBs
import UIKit

class ViewControllableMock: ViewControllable {

    var uiviewController: UIViewController = .init()

    var presentCallCount = 0
    var dismissCallCount = 0
    var presentAlertCallCount = 0

    func present(_ viewControllableToPresent: ViewControllable,
                 modalPresentationStyle: UIModalPresentationStyle = .fullScreen,
                 animated: Bool = false,
                 completion: (() -> Void)? = nil) {
        presentCallCount += 1
    }

    func dismiss(animated: Bool = false, completion: (() -> Void)? = nil) {
        dismissCallCount += 1
    }

    func presentAlert(withTitle title: String, message: String, action: [UIAlertAction]? = nil) {
        presentAlertCallCount += 1
    }
}
