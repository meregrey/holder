//
//  TextField.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/13.
//

import UIKit

final class TextField: UITextField {
    
    private enum Metric {
        static let inset = CGFloat(16)
        static let offset = CGFloat(-6)
        static let height = CGFloat(55)
        static let cornerRadius = CGFloat(12)
        static let borderWidth = CGFloat(1)
    }
    
    private enum Font {
        static let text = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    init(placeholder: String? = nil,
         keyboardType: UIKeyboardType = .default,
         theme: ViewTheme = .normal) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        configure(with: theme)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.placeholder = nil
        self.keyboardType = .default
        configure(with: .normal)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.textRect(forBounds: bounds)
        return CGRect(x: Metric.inset, y: 0, width: originalRect.width - Metric.inset * 2, height: originalRect.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.editingRect(forBounds: bounds)
        return CGRect(x: Metric.inset, y: 0, width: originalRect.width - Metric.inset * 2, height: originalRect.height)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: Metric.offset, dy: 0)
    }
    
    private func configure(with theme: ViewTheme) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Metric.height).isActive = true
        font = Font.text
        clearButtonMode = .whileEditing
        layer.cornerRadius = Metric.cornerRadius
        layer.cornerCurve = .continuous
        
        if theme == .sheet {
            textColor = Asset.Color.sheetTextColor
            backgroundColor = Asset.Color.sheetUpperBackgroundColor
            return
        }
        
        textColor = Asset.Color.primaryColor
        backgroundColor = Asset.Color.upperBackgroundColor
        layer.borderColor = Asset.Color.borderColor.cgColor
        layer.borderWidth = Metric.borderWidth
    }
}
