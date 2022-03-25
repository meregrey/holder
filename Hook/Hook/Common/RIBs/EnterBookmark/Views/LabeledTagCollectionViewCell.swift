//
//  LabeledTagCollectionViewCell.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/07.
//

import UIKit

final class LabeledTagCollectionViewCell: UICollectionViewCell {
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView(cornerRadius: 8)
        view.backgroundColor = Asset.Color.sheetCellBackgroundColor
        return view
    }()
    
    @AutoLayout private var tagNameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.tagNameLabel
        label.textColor = Asset.Color.sheetTextColor
        label.lineBreakMode = .byTruncatingMiddle
        return label
    }()
    
    private enum Font {
        static let tagNameLabel = UIFont.systemFont(ofSize: 15, weight: .semibold)
    }
    
    private enum Metric {
        static let tagNameLabelTop = CGFloat(8)
        static let tagNameLabelLeading = CGFloat(12)
        static let tagNameLabelTrailing = CGFloat(-12)
        static let tagNameLabelBottom = CGFloat(-8)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    static func fittingSize(with tag: Tag, height: CGFloat, maximumWidth: CGFloat) -> CGSize {
        let cell = LabeledTagCollectionViewCell()
        cell.configure(with: tag)
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: height)
        let fittingSize = cell.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .fittingSizeLevel,
                                                        verticalFittingPriority: .required)
        return fittingSize.width < maximumWidth ? fittingSize : CGSize(width: maximumWidth, height: height)
    }
    
    func configure(with tag: Tag) {
        tagNameLabel.text = tag.name
    }
    
    private func configureViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(tagNameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            tagNameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metric.tagNameLabelTop),
            tagNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.tagNameLabelLeading),
            tagNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.tagNameLabelTrailing),
            tagNameLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Metric.tagNameLabelBottom)
        ])
    }
}
