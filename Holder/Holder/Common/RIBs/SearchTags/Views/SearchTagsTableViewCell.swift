//
//  SearchTagsTableViewCell.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/12.
//

import UIKit

final class SearchTagsTableViewCell: UITableViewCell {
    
    private(set) var text = "" {
        didSet { label.text = text }
    }
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView()
        view.backgroundColor = Asset.Color.sheetUpperBackgroundColor
        return view
    }()
    
    @AutoLayout private var label: UILabel = {
        let label = UILabel()
        label.font = Font.tagNameLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    private enum Font {
        static let tagNameLabel = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private enum Metric {
        static let containerViewTop = CGFloat(5)
        static let containerViewLeading = CGFloat(20)
        static let containerViewTrailing = CGFloat(-20)
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
    
    func configure(with text: String) {
        self.text = text
    }
    
    private func configureViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(containerView)
        containerView.addSubview(label)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metric.containerViewTop),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.containerViewLeading),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.containerViewTrailing),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metric.containerViewBottom),
            
            label.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.tagNameLabelLeading),
            label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.tagNameLabelTrailing)
        ])
    }
}
