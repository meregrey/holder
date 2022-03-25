//
//  AutoLayout.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/25.
//

import UIKit

@propertyWrapper
struct AutoLayout<T: UIView> {
    var wrappedValue: T {
        didSet { setAutoLayout() }
    }
    
    init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
        setAutoLayout()
    }
    
    func setAutoLayout() {
        wrappedValue.translatesAutoresizingMaskIntoConstraints = false
    }
}
