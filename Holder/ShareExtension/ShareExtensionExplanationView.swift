//
//  ShareExtensionExplanationView.swift
//  ShareExtension
//
//  Created by Yeojin Yoon on 2022/04/22.
//

import UIKit

protocol ShareExtensionExplanationViewListener: AnyObject {
    func okButtonDidTap()
}

final class ShareExtensionExplanationView: UIView {
    
    weak var listener: ShareExtensionExplanationViewListener?
    
    @AutoLayout private var explanationLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.LabelText.alreadySavedLink
        label.font = Font.explanationLabel
        label.textColor = Asset.Color.primaryColor
        label.textAlignment = .center
        return label
    }()
    
    @AutoLayout private var okButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ActionTitle.ok, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.backgroundColor = Asset.Color.primaryColor
        button.addTarget(self, action: #selector(okButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private enum Font {
        static let explanationLabel = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    private enum Metric {
        static let explanationLabelCenterY = CGFloat(-60)
        static let explanationLabelLeading = CGFloat(20)
        static let explanationLabelTrailing = CGFloat(-20)
        
        static let okButtonLeading = CGFloat(20)
        static let okButtonTrailing = CGFloat(-20)
        static let okButtonBottom = CGFloat(-40)
    }
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        backgroundColor = Asset.Color.sheetBaseBackgroundColor
        
        addSubview(explanationLabel)
        addSubview(okButton)
        
        NSLayoutConstraint.activate([
            explanationLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: Metric.explanationLabelCenterY),
            explanationLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.explanationLabelLeading),
            explanationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.explanationLabelTrailing),
            
            okButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.okButtonLeading),
            okButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.okButtonTrailing),
            okButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Metric.okButtonBottom)
        ])
    }
    
    @objc
    private func okButtonDidTap() {
        listener?.okButtonDidTap()
    }
}
