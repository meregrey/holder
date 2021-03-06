//
//  LabeledLinkTextField.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/15.
//

import UIKit

protocol LabeledLinkTextFieldListener: AnyObject {
    func textFieldDidBecomeFirstResponder()
}

final class LabeledLinkTextField: LabeledView {
    
    weak var listener: LabeledLinkTextFieldListener?
    var text: String? { textField.text }
    
    @AutoLayout private var textField: TextField
    
    init(header: String) {
        self.textField = TextField(placeholder: nil, keyboardType: .URL, style: .sheet)
        super.init(header: header, style: .sheet)
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
    
    func disable(includingTransparency isTransparent: Bool = true) {
        if isTransparent { alpha = 0.2 }
        isUserInteractionEnabled = false
    }
    
    func setText(_ text: String) {
        textField.text = text
    }
    
    private func configure() {
        textField.delegate = self
        addSubviewUnderLabel(textField)
    }
}

extension LabeledLinkTextField: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        listener?.textFieldDidBecomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
