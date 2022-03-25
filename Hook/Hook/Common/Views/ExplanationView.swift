//
//  ExplanationView.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/24.
//

import UIKit

final class ExplanationView: UIView {
    
    private let title: String
    private let explanation: String
    private let centerYConstant: CGFloat
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        return stackView
    }()
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        label.textAlignment = .center
        return label
    }()
    
    @AutoLayout private var explanationLabel: UILabel = {
        let label = UILabel()
        label.font = Font.explanationLabel
        label.textColor = Asset.Color.primaryColor
        label.numberOfLines = 0
        return label
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 22, weight: .bold)
        static let explanationLabel = UIFont.systemFont(ofSize: 16, weight: .medium)
    }
    
    private enum Metric {
        static let stackViewLeading = CGFloat(20)
        static let stackViewTrailing = CGFloat(-20)
    }
    
    init(title: String, explanation: String, centerYConstant: CGFloat = 40) {
        self.title = title
        self.explanation = explanation
        self.centerYConstant = centerYConstant
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        self.title = ""
        self.explanation = ""
        self.centerYConstant = 0
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        titleLabel.text = title
        explanationLabel.attributedText = explanationLabelAttributedText()
        backgroundColor = Asset.Color.baseBackgroundColor
        
        addSubview(stackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(explanationLabel)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerYConstant),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.stackViewTrailing)
        ])
    }
    
    private func explanationLabelAttributedText() -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.lineSpacing = 6
        return NSAttributedString(string: explanation, attributes: [.paragraphStyle: paragraphStyle])
    }
}
