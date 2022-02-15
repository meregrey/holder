//
//  LabeledTextField.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/15.
//

import UIKit

final class LabeledTextField: LabeledView {
    
    @AutoLayout private var textField: TextField
    
    var delegate: UITextFieldDelegate? {
        didSet { textField.delegate = delegate }
    }
    
    var text: String? { textField.text }
    
    init(header: String,
         keyboardType: UIKeyboardType = .default,
         theme: ViewTheme = .normal) {
        self.textField = TextField(placeholder: header, keyboardType: keyboardType, theme: theme)
        super.init(header: header, theme: theme)
        configure()
    }
    
    required init?(coder: NSCoder) {
        self.textField = TextField()
        super.init(coder: coder)
        configure()
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return textField.resignFirstResponder()
    }
    
    private func configure() {
        addSubviewUnderLabel(textField)
    }
}
