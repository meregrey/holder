//
//  AlertController.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/02/14.
//

import UIKit

final class AlertController: UIViewController {
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView()
        view.backgroundColor = Asset.Color.alertBackgroundColor
        return view
    }()
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        label.numberOfLines = 0
        return label
    }()
    
    @AutoLayout private var messageLabel: UILabel = {
        let label = UILabel()
        label.font = Font.messageLabel
        label.textColor = Asset.Color.primaryColor
        label.numberOfLines = 0
        return label
    }()
    
    @AutoLayout private var actionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.semanticContentAttribute = .forceRightToLeft
        stackView.alignment = .bottom
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 20, weight: .bold)
        static let messageLabel = UIFont.systemFont(ofSize: 15, weight: .medium)
    }
    
    private enum Metric {
        static let containerViewLeading = CGFloat(30)
        static let containerViewTrailing = CGFloat(-30)
        
        static let titleLabelTop = CGFloat(24)
        static let titleLabelLeading = CGFloat(24)
        static let titleLabelTrailing = CGFloat(-24)
        
        static let messageLabelTop = CGFloat(12)
        static let messageLabelLeading = CGFloat(24)
        static let messageLabelTrailing = CGFloat(-24)
        
        static let actionStackViewHeight = CGFloat(24)
        static let actionStackViewTop = CGFloat(30)
        static let actionStackViewTrailing = CGFloat(-24)
        static let actionStackViewBottom = CGFloat(-24)
    }
    
    init(title: String, message: String? = nil, action: Action? = nil) {
        super.init(nibName: nil, bundle: nil)
        configureViews(title: title, message: message, action: action)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews(title: "", message: nil, action: nil)
    }
    
    private func configureViews(title: String, message: String?, action: Action?) {
        var anchorForActionStackViewTop = titleLabel.bottomAnchor
        
        modalPresentationStyle = .overFullScreen
        modalTransitionStyle = .crossDissolve
        
        view.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        view.addSubview(containerView)
        
        titleLabel.attributedText = titleLabelAttributedText(title: title)
        containerView.addSubview(titleLabel)
        
        if let message = message {
            messageLabel.attributedText = messageLabelAttributedText(message: message)
            anchorForActionStackViewTop = messageLabel.bottomAnchor
            containerView.addSubview(messageLabel)
            NSLayoutConstraint.activate([
                messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metric.messageLabelTop),
                messageLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.messageLabelLeading),
                messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.messageLabelTrailing),
            ])
        }
        
        let actions = actions(with: action)
        actions.forEach { actionStackView.addArrangedSubview($0) }
        containerView.addSubview(actionStackView)
        
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.containerViewLeading),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.containerViewTrailing),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metric.titleLabelTop),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.titleLabelTrailing),
            
            actionStackView.heightAnchor.constraint(equalToConstant: Metric.actionStackViewHeight),
            actionStackView.topAnchor.constraint(equalTo: anchorForActionStackViewTop, constant: Metric.actionStackViewTop),
            actionStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.actionStackViewTrailing),
            actionStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Metric.actionStackViewBottom)
        ])
    }
    
    private func titleLabelAttributedText(title: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        return NSAttributedString(string: title, attributes: [.paragraphStyle: paragraphStyle])
    }
    
    private func messageLabelAttributedText(message: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        return NSAttributedString(string: message, attributes: [.paragraphStyle: paragraphStyle])
    }
    
    private func actions(with action: Action?) -> [Action] {
        let defaultActionTitle = action == nil ? LocalizedString.ActionTitle.ok : LocalizedString.ActionTitle.cancel
        let defaultAction = Action(title: defaultActionTitle, handler: handleDefaultAction)
        var actions = [defaultAction]
        if let action = action {
            action.listener = self
            actions.insert(action, at: 0)
        }
        return actions
    }
    
    @objc
    private func handleDefaultAction() {
        dismiss(animated: true)
    }
}

extension AlertController: ActionListener {
    
    func dismiss() {
        dismiss(animated: true)
    }
}
