//
//  SheetHeaderView.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/03.
//

import UIKit

protocol SheetHeaderViewListener: AnyObject {
    func cancelButtonDidTap()
}

final class SheetHeaderView: UIView {
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var cancelButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.cancelButton, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = Asset.Color.primaryColor
        button.addTarget(nil, action: #selector(cancelButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    private enum Image {
        static let cancelButton = UIImage(systemName: "xmark", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let height = CGFloat(66)
        
        static let titleLabelLeading = CGFloat(20)
        static let titleLabelTrailing = CGFloat(-20)
        
        static let cancelButtonWidthHeight = CGFloat(22)
        static let cancelButtonTrailing = CGFloat(-20)
    }
    
    weak var listener: SheetHeaderViewListener?
    
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
    
    private func configure() {
        addSubview(titleLabel)
        addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),
            
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(equalTo: cancelButton.leadingAnchor, constant: Metric.titleLabelTrailing),
            
            cancelButton.widthAnchor.constraint(equalToConstant: Metric.cancelButtonWidthHeight),
            cancelButton.heightAnchor.constraint(equalToConstant: Metric.cancelButtonWidthHeight),
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.cancelButtonTrailing)
        ])
    }
    
    @objc
    private func cancelButtonDidTap() {
        listener?.cancelButtonDidTap()
    }
}
