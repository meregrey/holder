//
//  SettingsOptionView.swift
//  Magboard
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
        let imageView = UIImageView(image: Image.forwardImageView)
        imageView.tintColor = Asset.Color.secondaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    @AutoLayout private var infoLabel: UILabel = {
        let label = UILabel()
        label.font = Font.infoLabel
        label.textColor = .lightGray
        label.textAlignment = .right
        return label
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 17, weight: .medium)
        static let infoLabel = UIFont.systemFont(ofSize: 17)
    }
    
    private enum Image {
        static let forwardImageView = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
    }
    
    private enum Metric {
        static let height = CGFloat(55)
        
        static let titleLabelLeading = CGFloat(20)
        static let titleLabelTrailing = CGFloat(-20)
        
        static let forwardImageViewWidthHeight = CGFloat(15)
        static let forwardImageViewTrailing = CGFloat(-20)
        
        static let infoLabelTrailing = CGFloat(-20)
    }
    
    init(title: String, info: String? = nil) {
        super.init(frame: .zero)
        configure(title: title, info: info)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(title: "", info: nil)
    }
    
    private func configure(title: String, info: String?) {
        titleLabel.text = title
        backgroundColor = Asset.Color.upperBackgroundColor
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.titleLabelTrailing)
        ])
        
        if info == nil {
            addSubview(forwardImageView)
            NSLayoutConstraint.activate([
                forwardImageView.widthAnchor.constraint(equalToConstant: Metric.forwardImageViewWidthHeight),
                forwardImageView.heightAnchor.constraint(equalToConstant: Metric.forwardImageViewWidthHeight),
                forwardImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                forwardImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.forwardImageViewTrailing)
            ])
        } else {
            infoLabel.text = info
            addSubview(infoLabel)
            NSLayoutConstraint.activate([
                infoLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                infoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.infoLabelTrailing)
            ])
        }
    }
}
