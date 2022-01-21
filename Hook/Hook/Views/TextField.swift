//
//  TextField.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/13.
//

import UIKit

final class TextField: UITextField {
    
    private enum Metric {
        static let inset = CGFloat(12)
        static let offset = CGFloat(-6)
        static let height = CGFloat(52)
        static let borderWidth = CGFloat(1)
        static let cornerRadius = CGFloat(12)
    }
    
    private enum Font {
        static let text = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    init(placeholder: String? = nil) {
        super.init(frame: .zero)
        self.placeholder = placeholder
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.placeholder = nil
        configure()
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
    
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: Metric.height).isActive = true
        font = Font.text
        clearButtonMode = .whileEditing
        backgroundColor = Asset.Color.upperBackgroundColor
        layer.borderColor = Asset.Color.borderColor.cgColor
        layer.borderWidth = Metric.borderWidth
        layer.cornerRadius = Metric.cornerRadius
        layer.cornerCurve = .continuous
    }
}
