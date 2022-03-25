//
//  CountLimitTextField.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/13.
//

import UIKit

final class CountLimitTextField: UIView {
    
    @AutoLayout private var headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    @AutoLayout private var headerLabel: UILabel = {
        let label = UILabel()
        label.font = Font.headerLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var countLabel: UILabel = {
        let label = UILabel()
        label.font = Font.countLabel
        label.textColor = Asset.Color.secondaryColor
        return label
    }()
    
    @AutoLayout private var textField: TextField
    
    private var countLimit: Int
    
    private enum Font {
        static let headerLabel = UIFont.systemFont(ofSize: 14, weight: .semibold)
        static let countLabel = UIFont.systemFont(ofSize: 12)
    }
    
    private enum Metric {
        static let textFieldTop = CGFloat(10)
    }
    
    var text: String? { textField.text }
    
    init(header: String, countLimit: Int) {
        self.textField = TextField(placeholder: header)
        self.countLimit = countLimit
        super.init(frame: .zero)
        registerToReceiveNotification()
        configure(with: header)
    }
    
    required init?(coder: NSCoder) {
        self.textField = TextField(placeholder: "")
        self.countLimit = 0
        super.init(coder: coder)
        registerToReceiveNotification()
        configure(with: "")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return textField.becomeFirstResponder()
    }
    
    func setText(_ text: String) {
        textField.text = text
        countLabel.text = "\(text.count)/\(countLimit)"
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(textDidChange),
                                       name: UITextField.textDidChangeNotification)
    }
    
    @objc private func textDidChange() {
        var count = textField.text?.count ?? 0
        let limit = countLimit
        
        if count > limit {
            let substring = textField.text?.prefix(limit) ?? Substring()
            let string = String(substring)
            textField.text = string
            
            DispatchQueue.main.async {
                let position = self.textField.endOfDocument
                self.textField.selectedTextRange = self.textField.textRange(from: position, to: position)
            }
            
            count = limit
        }
        
        countLabel.text = "\(count)/\(limit)"
    }
    
    private func configure(with header: String) {
        headerLabel.text = header
        countLabel.text = "0/\(countLimit)"
        textField.delegate = self
        
        addSubview(headerStackView)
        addSubview(textField)
        headerStackView.addArrangedSubview(headerLabel)
        headerStackView.addArrangedSubview(countLabel)
        
        NSLayoutConstraint.activate([
            headerStackView.topAnchor.constraint(equalTo: topAnchor),
            headerStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            textField.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: Metric.textFieldTop),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    private func animateTextField() {
        let originalFrame = textField.frame
        
        UIView.animateKeyframes(withDuration: 0.2, delay: 0.0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.25) {
                var newFrame = self.textField.frame
                newFrame.origin.x = originalFrame.origin.x - 10
                self.textField.frame = newFrame
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25) {
                self.textField.frame = originalFrame
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.25) {
                var newFrame = self.textField.frame
                newFrame.origin.x = originalFrame.origin.x + 10
                self.textField.frame = newFrame
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25) {
                self.textField.frame = originalFrame
            }
        }
    }
}

extension CountLimitTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let count = textField.text?.count ?? 0
        
        if count < countLimit { return true }
        if count == countLimit, string.count == 0 { return true }
        
        animateTextField()
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
