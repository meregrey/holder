//
//  EnterTagViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/12.
//

import RIBs
import UIKit

protocol EnterTagPresentableListener: AnyObject {
    func backButtonDidTap()
    func saveButtonDidTap(with tag: Tag)
}

final class EnterTagViewController: UIViewController, EnterTagPresentable, EnterTagViewControllable {
    
    @AutoLayout private var containerView = UIView()
    
    @AutoLayout private var labeledTextField = LabeledTextField(header: LocalizedString.TextFieldHeader.tagName,
                                                                countLimit: Number.countLimit)
    
    @AutoLayout private var saveButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ButtonTitle.save, for: .normal)
        button.setTitleColor(Color.saveButtonTitle, for: .normal)
        button.titleLabel?.font = Font.saveButton
        button.backgroundColor = Color.saveButtonBackground
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    
    private enum Number {
        static let countLimit = 20
    }
    
    private enum Color {
        static let saveButtonTitle = UIColor.white
        static let saveButtonBackground = UIColor.black
    }
    
    private enum Font {
        static let saveButton = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    private enum Image {
        static let back = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let labeledTextFieldTop = CGFloat(200)
        static let labeledTextFieldLeading = CGFloat(20)
        static let labeledTextFieldTrailing = CGFloat(-20)
        
        static let saveButtonHeight = RoundedCornerButton.height
        static let saveButtonLeading = CGFloat(20)
        static let saveButtonTrailing = CGFloat(-20)
        static let saveButtonBottom = CGFloat(-40)
    }

    weak var listener: EnterTagPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        registerToReceiveNotification()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerToReceiveNotification()
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        labeledTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let containerViewHeight = view.frame.height - keyboardFrame.height + 20
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.containerViewHeightConstraint?.constant = containerViewHeight
            self.view.layoutIfNeeded()
        })
    }
    
    @objc private func keyboardWillHide() {
        let containerViewHeight = view.frame.height
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.containerViewHeightConstraint?.constant = containerViewHeight
            self.view.layoutIfNeeded()
        })
    }
    
    private func configureViews() {
        title = LocalizedString.ViewTitle.addTag
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.back, style: .done, target: self, action: #selector(backButtonDidTap))
        
        view.backgroundColor = .white
        
        containerViewHeightConstraint = NSLayoutConstraint(item: containerView,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .notAnAttribute,
                                                           multiplier: 1,
                                                           constant: view.frame.height)
        
        view.addSubview(containerView)
        containerView.addSubview(labeledTextField)
        containerView.addSubview(saveButton)
        containerView.addConstraint(containerViewHeightConstraint ?? NSLayoutConstraint())
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            labeledTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metric.labeledTextFieldTop),
            labeledTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.labeledTextFieldLeading),
            labeledTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.labeledTextFieldTrailing),
            
            saveButton.heightAnchor.constraint(equalToConstant: Metric.saveButtonHeight),
            saveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.saveButtonLeading),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.saveButtonTrailing),
            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Metric.saveButtonBottom)
        ])
    }
    
    @objc private func backButtonDidTap() {
        listener?.backButtonDidTap()
    }
    
    @objc private func saveButtonDidTap() {
        if let tagName = labeledTextField.text, tagName.count > 0 {
            listener?.saveButtonDidTap(with: Tag(name: tagName))
        }
    }
}
