//
//  TagSettingsTableViewCell.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import UIKit

final class TagSettingsTableViewCell: UITableViewCell {
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView()
        view.backgroundColor = Asset.Color.upperBackgroundColor
        return view
    }()
    
    @AutoLayout private var tagNameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.tagNameLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var forwardImageView: UIImageView = {
        let imageView = UIImageView(image: Image.forward)
        imageView.tintColor = Asset.Color.secondaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private enum Font {
        static let tagNameLabel = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private enum Image {
        static let forward = UIImage(systemName: "chevron.right", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
    }
    
    private enum Metric {
        static let containerViewTop = CGFloat(5)
        static let containerViewLeading = CGFloat(20)
        static let containerViewTrailing = CGFloat(-20)
        static let containerViewBottom = CGFloat(-5)
        
        static let tagNameLabelLeading = CGFloat(20)
        static let tagNameLabelTrailing = CGFloat(-20)
        
        static let forwardImageViewWidthHeight = CGFloat(15)
        static let forwardImageViewTrailing = CGFloat(-20)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        forwardImageView.isHidden = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let text = tagNameLabel.text, text == TagName.all.localized { return }
        
        UIView.animate(withDuration: 0.2, animations: {
            self.containerView.backgroundColor = Asset.Color.selectedBackgroundColor
        }, completion: { _ in
            self.containerView.backgroundColor = Asset.Color.upperBackgroundColor
        })
    }
    
    func configure(with tag: Tag) {
        if tag.name == TagName.all {
            tagNameLabel.text = tag.name.localized
            forwardImageView.isHidden = true
        } else {
            tagNameLabel.text = tag.name
        }
    }
    
    private func configureViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(tagNameLabel)
        containerView.addSubview(forwardImageView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metric.containerViewTop),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.containerViewLeading),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.containerViewTrailing),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metric.containerViewBottom),
            
            tagNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            tagNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.tagNameLabelLeading),
            tagNameLabel.trailingAnchor.constraint(equalTo: forwardImageView.leadingAnchor, constant: Metric.tagNameLabelTrailing),
            
            forwardImageView.widthAnchor.constraint(equalToConstant: Metric.forwardImageViewWidthHeight),
            forwardImageView.heightAnchor.constraint(equalToConstant: Metric.forwardImageViewWidthHeight),
            forwardImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            forwardImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.forwardImageViewTrailing)
        ])
    }
}
