//
//  EditTagsTableViewCell.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/17.
//

import UIKit

final class EditTagsTableViewCell: UITableViewCell {
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView()
        view.backgroundColor = Asset.Color.upperBackgroundColor
        return view
    }()
    
    @AutoLayout private var tagNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Color.primaryColor
        label.font = Font.tagNameLabel
        return label
    }()
    
    private enum Font {
        static let tagNameLabel = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private enum Metric {
        static let containerViewTop = CGFloat(5)
        static let containerViewLeading = CGFloat(20)
        static let containerViewTrailing = CGFloat(-10)
        static let containerViewBottom = CGFloat(-5)
        
        static let tagNameLabelLeading = CGFloat(20)
        static let tagNameLabelTrailing = CGFloat(-20)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func configure(with tag: Tag) {
        if tag.name == TagName.all {
            tagNameLabel.text = tag.name.localized
        } else {
            tagNameLabel.text = tag.name
        }
    }
    
    private func configureViews() {
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(tagNameLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metric.containerViewTop),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.containerViewLeading),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.containerViewTrailing),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metric.containerViewBottom),
            
            tagNameLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.tagNameLabelLeading),
            tagNameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.tagNameLabelTrailing),
            tagNameLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
}
