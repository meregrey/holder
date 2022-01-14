//
//  TagSettingsTableViewCell.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import UIKit

final class TagSettingsTableViewCell: UITableViewCell {
    
    @AutoLayout private var tagNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    
    private let accessoryImageView: UIImageView = {
        let imageView = UIImageView(image: Image.accessoryView)
        imageView.tintColor = Color.accessoryView
        return imageView
    }()
    
    private enum Image {
        static let accessoryView = UIImage(systemName: "chevron.right",
                                           withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Color {
        static let accessoryView = UIColor.lightGray
    }
    
    private enum Metric {
        static let accessoryView = CGRect(x: 0, y: 0, width: 12, height: 12)
        static let tagNameLabelTop = CGFloat(20)
        static let tagNameLabelLeading = CGFloat(20)
        static let tagNameLabelTrailing = CGFloat(20)
        static let tagNameLabelBottom = CGFloat(-20)
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
        accessoryView?.isHidden = false
    }
    
    func configure(with tag: Tag) {
        if tag.name == TagName.all {
            tagNameLabel.text = tag.name.localized
        } else {
            tagNameLabel.text = tag.name
        }
    }
    
    private func configureViews() {
        accessoryView = accessoryImageView
        accessoryView?.bounds = Metric.accessoryView
        
        contentView.addSubview(tagNameLabel)
        
        NSLayoutConstraint.activate([
            tagNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metric.tagNameLabelTop),
            tagNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.tagNameLabelLeading),
            tagNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.tagNameLabelTrailing),
            tagNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metric.tagNameLabelBottom)
        ])
    }
}
