//
//  ViewControllable.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import RIBs

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
}
