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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func displayAlert(withTitle title: String, message: String) {
        presentAlert(withTitle: title, message: message)
    }
}
