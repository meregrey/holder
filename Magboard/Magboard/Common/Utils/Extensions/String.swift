//
//  String.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import Foundation

extension String {
    var localized: Self { NSLocalizedString(self, comment: "") }
}
