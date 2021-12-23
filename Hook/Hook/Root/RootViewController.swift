//
//  RootViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/23.
//

import RIBs
import RxSwift
import UIKit

protocol RootPresentableListener: AnyObject {}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?
}