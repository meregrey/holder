//
//  AccountViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol AccountPresentableListener: AnyObject {}

final class AccountViewController: UIViewController, AccountPresentable, AccountViewControllable {

    weak var listener: AccountPresentableListener?
}
