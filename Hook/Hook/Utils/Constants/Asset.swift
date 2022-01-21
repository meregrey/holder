//
//  Asset.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/18.
//

import UIKit

enum Asset {
    enum Color {
        static let primaryColor = UIColor(named: "PrimaryColor") ?? UIColor()
        static let secondaryColor = UIColor(named: "SecondaryColor") ?? UIColor()
        static let tertiaryColor = UIColor(named: "TertiaryColor") ?? UIColor()
        static let baseBackgroundColor = UIColor(named: "BaseBackgroundColor") ?? UIColor()
        static let upperBackgroundColor = UIColor(named: "UpperBackgroundColor") ?? UIColor()
        static let selectedBackgroundColor = UIColor(named: "SelectedBackgroundColor") ?? UIColor()
        static let borderColor = UIColor(named: "BorderColor") ?? UIColor()
    }
}
