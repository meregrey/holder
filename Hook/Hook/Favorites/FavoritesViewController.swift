//
//  FavoritesViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs
import UIKit

protocol FavoritesPresentableListener: AnyObject {}

final class FavoritesViewController: UIViewController, FavoritesPresentable, FavoritesViewControllable {

    weak var listener: FavoritesPresentableListener?
}
