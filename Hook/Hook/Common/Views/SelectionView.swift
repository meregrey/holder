//
//  SelectionView.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import UIKit

final class SelectionView: UIView {
    
    @AutoLayout private var titleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Font.titleButton
        button.setTitleColor(Asset.Color.primaryColor, for: .normal)
        return button
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
        static let titleButton = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private enum Image {
        static let checkmarkImageView = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
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
    
    func addTarget(_ target: Any?, action: Selector) {
        titleButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func select(_ flag: Bool) {
        checkmarkImageView.isHidden = !flag
    }
    
    private func configure(with title: String) {
        titleButton.setTitle(title, for: .normal)
        
        addSubview(titleButton)
        addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: topAnchor),
            titleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Metric.checkmarkImageViewWidthHeight),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: Metric.checkmarkImageViewWidthHeight),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
