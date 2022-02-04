//
//  Asset.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/18.
//

import UIKit

enum Asset {
    enum Color {
        static let primaryColor = UIColor(named: "PrimaryColor") ?? .clear
        static let secondaryColor = UIColor(named: "SecondaryColor") ?? .clear
        static let tertiaryColor = UIColor(named: "TertiaryColor") ?? .clear
        
        static let baseBackgroundColor = UIColor(named: "BaseBackgroundColor") ?? .clear
        static let upperBackgroundColor = UIColor(named: "UpperBackgroundColor") ?? .clear
        static let selectedBackgroundColor = UIColor(named: "SelectedBackgroundColor") ?? .clear
        static let sheetBaseBackgroundColor = UIColor(named: "SheetBaseBackgroundColor") ?? .clear
        static let sheetUpperBackgroundColor = UIColor(named: "SheetUpperBackgroundColor") ?? .clear
        
        static let borderColor = UIColor(named: "BorderColor") ?? .clear
        static let sheetBorderColor = UIColor(named: "SheetBorderColor") ?? .clear
        
        static let sheetLabelColor = UIColor(named: "SheetLabelColor") ?? .clear
    }
}
