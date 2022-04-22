//
//  RecentSearchesTableViewCell.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import UIKit

final class RecentSearchesTableViewCell: UITableViewCell {
    
    @AutoLayout private var searchTermLabel: UILabel = {
        let label = UILabel()
        label.font = Font.searchTermLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    private enum Font {
        static let searchTermLabel = UIFont.systemFont(ofSize: 19, weight: .medium)
    }
    
    private enum Metric {
        static let searchTermLabelLeading = CGFloat(20)
        static let searchTermLabelTrailing = CGFloat(-20)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func configure(with searchTerm: String) {
        searchTermLabel.text = searchTerm
    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = Asset.Color.baseBackgroundColor
        
        contentView.addSubview(searchTermLabel)
        
        NSLayoutConstraint.activate([
            searchTermLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            searchTermLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.searchTermLabelLeading),
            searchTermLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.searchTermLabelTrailing)
        ])
    }
}
