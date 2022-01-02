//
//  LoggedInViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol LoggedInPresentableListener: AnyObject {}

final class LoggedInViewController: UIViewController, LoggedInPresentable, LoggedInViewControllable {
    
    weak var listener: LoggedInPresentableListener?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
