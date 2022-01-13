//
//  LabeledTextField.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/13.
//

import UIKit

final class LabeledTextField: UIView {
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        return stackView
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.headerLabel
        return label
    }()
    
    private let textField: TextField
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Font.countLabel
        label.textColor = Color.countLabel
        label.text = "0/\(countLimit ?? 0)"
        return label
    }()
    
    private var countLimit: Int?
    
    private enum Font {
        static let headerLabel = UIFont.systemFont(ofSize: 14, weight: .medium)
        static let countLabel = UIFont.systemFont(ofSize: 12)
    }
    
    private enum Color {
        static let countLabel = UIColor.lightGray
    }
    
    private enum Metric {
        static let textFieldTop = CGFloat(10)
    }
    
    init(header: String, countLimit: Int? = nil) {
        self.headerLabel.text = header
        self.textField = TextField(placeholder: header)
        self.countLimit = countLimit
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        self.headerLabel.text = ""
        self.textField = TextField(placeholder: "")
        self.countLimit = nil
        super.init(coder: coder)
        configure()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    private func configure() {
        configureTextField()
        
        addSubview(headerStackView)
        addSubview(textField)
        
        headerStackView.addArrangedSubview(headerLabel)
        if let countLimit = countLimit, countLimit > 0 { headerStackView.addArrangedSubview(countLabel) }
        
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
    
    private func configureTextField() {
        textField.delegate = self
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(textFieldDidChange),
                                               name: UITextField.textDidChangeNotification,
                                               object: textField)
    }
    
    @objc private func textFieldDidChange() {
        let count = textField.text?.count ?? 0
        let limit = countLimit ?? 0
        countLabel.text = "\(count)/\(limit)"
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

extension LabeledTextField: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if countLimit == nil { return true }
        
        let count = textField.text?.count ?? 0
        let limit = countLimit ?? 0
        
        if count < limit { return true }
        if count == limit, string.count == 0 { return true }
        
        animateTextField()
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
