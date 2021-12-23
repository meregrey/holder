//
//  LoggedOutViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/24.
//

import RIBs
import RxSwift
import UIKit

protocol LoggedOutPresentableListener: AnyObject {}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {

    weak var listener: LoggedOutPresentableListener?
}
