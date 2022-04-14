//
//  TagBarCollectionViewCell.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/08.
//

import UIKit

final class TagBarCollectionViewCell: UICollectionViewCell {
    
    @AutoLayout private var tagNameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.tagNameLabel
        label.textColor = Asset.Color.secondaryColor
        return label
    }()
    
    private enum Font {
        static let tagNameLabel = UIFont.systemFont(ofSize: 22, weight: .bold)
    }
    
    private enum Metric {
        static let tagNameLabelLeading = CGFloat(10)
        static let tagNameLabelTrailing = CGFloat(-10)
    }
    
    override var isSelected: Bool {
        didSet { tagNameLabel.textColor = isSelected ? Asset.Color.primaryColor : Asset.Color.secondaryColor }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    static func fittingSize(with tag: Tag, height: CGFloat) -> CGSize {
        let cell = TagBarCollectionViewCell()
        cell.configure(with: tag)
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: height)
        return cell.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .fittingSizeLevel,
                                                        verticalFittingPriority: .required)
    }
    
    func configure(with tag: Tag) {
        if tag.name == TagName.all {
            tagNameLabel.text = tag.name.localized
        } else {
            tagNameLabel.text = tag.name
        }
    }
    
    private func configureViews() {
        contentView.addSubview(tagNameLabel)
        
        NSLayoutConstraint.activate([
            tagNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.tagNameLabelLeading),
            tagNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.tagNameLabelTrailing),
            tagNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
