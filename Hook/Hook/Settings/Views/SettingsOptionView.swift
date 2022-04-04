//
//  SettingsOptionView.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import UIKit

final class SettingsOptionView: UIControl {
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var forwardImageView: UIImageView = {
        let imageView = UIImageView(image: Image.forward)
        imageView.tintColor = Asset.Color.secondaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabelTrailingConstraint = NSLayoutConstraint(item: titleLabel,
                                                                       attribute: .trailing,
                                                                       relatedBy: .equal,
                                                                       toItem: self,
                                                                       attribute: .trailing,
                                                                       multiplier: 1,
                                                                       constant: Metric.titleLabelTrailing)
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    private enum Image {
        static let forward = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
    }
    
    private enum Metric {
        static let height = CGFloat(55)
        
        static let titleLabelLeading = CGFloat(20)
        static let titleLabelTrailing = CGFloat(-20)
        
        static let forwardImageViewWidthHeight = CGFloat(15)
        static let forwardImageViewTrailing = CGFloat(-20)
    }
    
    init(title: String, centered: Bool = false, showsForwardImageView: Bool = true) {
        super.init(frame: .zero)
        configure(title: title, centered: centered, showsForwardImageView: showsForwardImageView)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(title: "", centered: false, showsForwardImageView: false)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    private func configure(title: String, centered isCentered: Bool, showsForwardImageView: Bool) {
        titleLabel.text = title
        backgroundColor = Asset.Color.upperBackgroundColor
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        
        addSubview(titleLabel)
        titleLabelTrailingConstraint.isActive = true
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.titleLabelLeading)
        ])
        
        if isCentered {
            titleLabel.textAlignment = .center
            return
        }
        
        if showsForwardImageView {
            addSubview(forwardImageView)
            titleLabelTrailingConstraint.constant = Metric.titleLabelTrailing + Metric.forwardImageViewWidthHeight + Metric.forwardImageViewTrailing
            NSLayoutConstraint.activate([
                forwardImageView.widthAnchor.constraint(equalToConstant: Metric.forwardImageViewWidthHeight),
                forwardImageView.heightAnchor.constraint(equalToConstant: Metric.forwardImageViewWidthHeight),
                forwardImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                forwardImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.forwardImageViewTrailing)
            ])
        }
    }
}
