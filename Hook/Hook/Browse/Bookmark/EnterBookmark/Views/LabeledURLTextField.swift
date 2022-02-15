//
//  LabeledURLTextField.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/15.
//

import UIKit

final class LabeledURLTextField: LabeledView {
    
    @AutoLayout private var textField: TextField
    
    var delegate: UITextFieldDelegate? {
        didSet { textField.delegate = delegate }
    }
    
    var text: String? { textField.text }
    
    init(header: String) {
        self.textField = TextField(placeholder: nil, keyboardType: .URL, theme: .sheet)
        super.init(header: header, theme: .sheet)
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
