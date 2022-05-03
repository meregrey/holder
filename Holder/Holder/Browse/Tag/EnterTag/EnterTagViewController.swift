//
//  EnterTagViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/12.
//

import RIBs
import UIKit

protocol EnterTagPresentableListener: AnyObject {
    func backButtonDidTap()
    func saveButtonDidTap(tag: Tag)
    func didRemove()
}

final class EnterTagViewController: UIViewController, EnterTagPresentable, EnterTagViewControllable {
    
    weak var listener: EnterTagPresentableListener?
    
    private let mode: EnterTagMode
    
    @AutoLayout private var containerView = UIView()
    
    @AutoLayout private var countLimitTextField = CountLimitTextField(header: LocalizedString.LabelText.tagName,
                                                                      countLimit: Number.countLimit)
    
    @AutoLayout private var saveButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ActionTitle.save, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.backgroundColor = Asset.Color.primaryColor
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private var containerViewHeightConstraint: NSLayoutConstraint?
    
    private enum Number {
        static let countLimit = 20
    }
    
    private enum Image {
        static let backButton = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let labeledTextFieldTop = CGFloat(200)
        static let labeledTextFieldLeading = CGFloat(20)
        static let labeledTextFieldTrailing = CGFloat(-20)
        
        static let saveButtonLeading = CGFloat(20)
        static let saveButtonTrailing = CGFloat(-20)
        static let saveButtonBottom = CGFloat(-40)
    }
    
    init(mode: EnterTagMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
        registerToReceiveNotification()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        self.mode = .add
        super.init(coder: coder)
        registerToReceiveNotification()
        configureViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countLimitTextField.becomeFirstResponder()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    func displayAlert(title: String) {
        view.endEditing(true)
        presentAlert(title: title)
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: UIResponder.keyboardWillShowNotification)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let containerViewHeight = view.frame.height - keyboardFrame.height + 20
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.containerViewHeightConstraint?.constant = containerViewHeight
            self.view.layoutIfNeeded()
        })
    }
    
    @objc
    private func keyboardWillHide() {
        let containerViewHeight = view.frame.height
        
        UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseIn, animations: {
            self.containerViewHeightConstraint?.constant = containerViewHeight
            self.view.layoutIfNeeded()
        })
    }
    
    private func configureViews() {
        switch mode {
        case .add:
            title = LocalizedString.ViewTitle.addTag
        case .edit(let tag):
            title = LocalizedString.ViewTitle.editTag
            countLimitTextField.setText(tag.name)
        }
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.backButton, style: .done, target: self, action: #selector(backButtonDidTap))
        view.backgroundColor = Asset.Color.baseBackgroundColor
        containerViewHeightConstraint = NSLayoutConstraint(item: containerView,
                                                           attribute: .height,
                                                           relatedBy: .equal,
                                                           toItem: nil,
                                                           attribute: .notAnAttribute,
                                                           multiplier: 1,
                                                           constant: view.frame.height)
        
        view.addSubview(containerView)
        containerView.addSubview(countLimitTextField)
        containerView.addSubview(saveButton)
        containerView.addConstraint(containerViewHeightConstraint ?? NSLayoutConstraint())
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            countLimitTextField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metric.labeledTextFieldTop),
            countLimitTextField.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.labeledTextFieldLeading),
            countLimitTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.labeledTextFieldTrailing),
            
            saveButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.saveButtonLeading),
            saveButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.saveButtonTrailing),
            saveButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Metric.saveButtonBottom)
        ])
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.backButtonDidTap()
    }
    
    @objc
    private func saveButtonDidTap() {
        if let tagName = countLimitTextField.text, tagName.count > 0 {
            listener?.saveButtonDidTap(tag: Tag(name: tagName))
        }
    }
}
