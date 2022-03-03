//
//  RootViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs
import UIKit

protocol RootPresentableListener: AnyObject {}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func displayAlert(title: String, message: String) {
        presentAlert(title: title, message: message)
    }
}
