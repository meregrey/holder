//
//  LabeledView.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/07.
//

import UIKit

class LabeledView: UIView {
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    
    @AutoLayout private var label: UILabel = {
        let label = UILabel()
        label.font = Font.label
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    private enum Font {
        static let label = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    init(header: String, style: ViewStyle = .normal) {
        super.init(frame: .zero)
        self.label.text = header
        if style == .sheet { self.label.textColor = Asset.Color.sheetTextColor }
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func addSubviewUnderLabel(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    private func configureViews() {
        addSubview(stackView)
        stackView.addArrangedSubview(label)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
