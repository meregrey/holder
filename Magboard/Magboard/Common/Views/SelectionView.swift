//
//  SelectionView.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import UIKit

final class SelectionView: UIControl {
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Image.checkmarkImageView
        imageView.tintColor = Asset.Color.primaryColor
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private enum Image {
        static let checkmarkImageView = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let height = CGFloat(40)
        
        static let checkmarkImageViewWidthHeight = CGFloat(22)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        configure(with: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(with: "")
    }
    
    func select(_ flag: Bool) {
        checkmarkImageView.isHidden = !flag
    }
    
    private func configure(with title: String) {
        titleLabel.text = title
        
        addSubview(titleLabel)
        addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Metric.checkmarkImageViewWidthHeight),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: Metric.checkmarkImageViewWidthHeight),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
