//
//  SelectTagsTableViewCell.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/04.
//

import UIKit

final class SelectTagsTableViewCell: UITableViewCell {
    
    @AutoLayout private var roundedCornerView: RoundedCornerView = {
        let view = RoundedCornerView()
        view.backgroundColor = Asset.Color.sheetUpperBackgroundColor
        return view
    }()
    
    @AutoLayout private var tagNameLabel: UILabel = {
        let label = UILabel()
        label.font = Font.tagNameLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var checkmarkImageView: UIImageView = {
        let imageView = UIImageView(image: Image.checkmark)
        imageView.isHidden = true
        imageView.tintColor = Asset.Color.primaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private enum Font {
        static let tagNameLabel = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private enum Image {
        static let checkmark = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
    }
    
    private enum Metric {
        static let roundedCornerViewTop = CGFloat(5)
        static let roundedCornerViewLeading = CGFloat(20)
        static let roundedCornerViewTrailing = CGFloat(-20)
        static let roundedCornerViewBottom = CGFloat(-5)
        
        static let tagNameLabelLeading = CGFloat(20)
        static let tagNameLabelTrailing = CGFloat(-20)
        
        static let checkmarkImageViewWidthHeight = CGFloat(24)
        static let checkmarkImageViewTrailing = CGFloat(-20)
    }
    
    var isChecked = false {
        didSet { checkmarkImageView.isHidden = !isChecked }
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
        checkmarkImageView.isHidden = true
    }
    
    func configure(with tag: Tag, selected flag: Bool) {
        tagNameLabel.text = tag.name
        isChecked = flag
    }
    
    private func configureViews() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(roundedCornerView)
        contentView.addSubview(checkmarkImageView)
        roundedCornerView.addSubview(tagNameLabel)
        
        NSLayoutConstraint.activate([
            roundedCornerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metric.roundedCornerViewTop),
            roundedCornerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.roundedCornerViewLeading),
            roundedCornerView.trailingAnchor.constraint(equalTo: checkmarkImageView.leadingAnchor, constant: Metric.roundedCornerViewTrailing),
            roundedCornerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metric.roundedCornerViewBottom),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Metric.checkmarkImageViewWidthHeight),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: Metric.checkmarkImageViewWidthHeight),
            checkmarkImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.checkmarkImageViewTrailing),
            
            tagNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            tagNameLabel.leadingAnchor.constraint(equalTo: roundedCornerView.leadingAnchor, constant: Metric.tagNameLabelLeading),
            tagNameLabel.trailingAnchor.constraint(equalTo: roundedCornerView.trailingAnchor, constant: Metric.tagNameLabelTrailing)
        ])
    }
}
