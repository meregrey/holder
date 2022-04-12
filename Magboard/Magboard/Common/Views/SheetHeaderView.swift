//
//  SheetHeaderView.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/02/03.
//

import UIKit

final class SheetHeaderView: UIView {
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.closeButton, for: .normal)
        button.tintColor = Asset.Color.primaryColor
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    private enum Image {
        static let closeButton = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let height = CGFloat(66)
        
        static let titleLabelLeading = CGFloat(20)
        static let titleLabelTrailing = CGFloat(-20)
        
        static let closeButtonWidthHeight = CGFloat(22)
        static let closeButtonTrailing = CGFloat(-20)
    }
    
    init(title: String? = nil) {
        super.init(frame: .zero)
        self.titleLabel.text = title
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func addTargetToCloseButton(_ target: AnyObject, action: Selector) {
        closeButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: Metric.titleLabelTrailing),
            
            closeButton.widthAnchor.constraint(equalToConstant: Metric.closeButtonWidthHeight),
            closeButton.heightAnchor.constraint(equalToConstant: Metric.closeButtonWidthHeight),
            closeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.closeButtonTrailing)
        ])
    }
}
