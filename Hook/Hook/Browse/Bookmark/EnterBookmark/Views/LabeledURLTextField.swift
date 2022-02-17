//
//  LabeledURLTextField.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/15.
//

import UIKit

protocol LabeledURLTextFieldListener: AnyObject {
    func textFieldDidBecomeFirstResponder()
}

final class LabeledURLTextField: LabeledView {
    
    @AutoLayout private var textField: TextField
    
    var text: String? { textField.text }
    
    weak var listener: LabeledURLTextFieldListener?
    
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
    
    private func configure() {
        textField.delegate = self
        addSubviewUnderLabel(textField)
    }
}

extension LabeledURLTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        listener?.textFieldDidBecomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
