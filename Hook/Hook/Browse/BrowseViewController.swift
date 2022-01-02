//
//  BrowseViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol BrowsePresentableListener: AnyObject {}

final class BrowseViewController: UIViewController, BrowsePresentable, BrowseViewControllable {

    weak var listener: BrowsePresentableListener?
}
