//
//  BookmarkListTableViewCell.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/22.
//

import UIKit

final class BookmarkListTableViewCell: UITableViewCell {
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView()
        view.backgroundColor = Asset.Color.upperBackgroundColor
        return view
    }()
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = Metric.labelPreferredMaxLayoutWidth
        return label
    }()
    
    @AutoLayout private var hostLabel: UILabel = {
        let label = UILabel()
        label.font = Font.hostLabel
        label.textColor = Asset.Color.secondaryColor
        return label
    }()
    
    @AutoLayout private var noteLabel: UILabel = {
        let label = UILabel()
        label.font = Font.noteLabel
        label.textColor = Asset.Color.secondaryColor
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = Metric.labelPreferredMaxLayoutWidth
        return label
    }()
    
    @AutoLayout private var thumbnailImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray6
        view.layer.cornerRadius = 5
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let hostLabel = UIFont.systemFont(ofSize: 14)
        static let noteLabel = UIFont.systemFont(ofSize: 14)
    }
    
    private enum Metric {
        static let containerViewTop = CGFloat(8)
        static let containerViewLeading = CGFloat(20)
        static let containerViewTrailing = CGFloat(-20)
        static let containerViewBottom = CGFloat(-8)
        
        static let stackViewTop = CGFloat(20)
        static let stackViewLeading = CGFloat(16)
        static let stackViewTrailing = CGFloat(-16)
        static let stackViewBottom = CGFloat(-20)
        
        static let thumbnailImageViewWidth = CGFloat(90)
        static let thumbnailImageViewHeight = CGFloat(60)
        static let thumbnailImageViewTrailing = CGFloat(-16)
        
        static let labelPreferredMaxLayoutWidth = UIScreen.main.bounds.width - (containerViewLeading + (-containerViewTrailing) + stackViewLeading + (-stackViewTrailing) + thumbnailImageViewWidth + (-thumbnailImageViewTrailing))
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
        stackView.removeArrangedSubview(noteLabel)
        noteLabel.removeFromSuperview()
    }
    
    func configure(with bookmarkEntity: BookmarkEntity) {
        titleLabel.text = bookmarkEntity.title ?? bookmarkEntity.host ?? "Unknown Title"
        hostLabel.text = bookmarkEntity.host ?? "Unknown Host"
        if let note = bookmarkEntity.note, note.count > 0 {
            noteLabel.text = note
            stackView.addArrangedSubview(noteLabel)
        }
    }
    
//    func configure(with bookmark: Bookmark) {
//        titleLabel.text = bookmark.title ?? bookmark.host ?? "Unknown Title"
//        hostLabel.text = bookmark.host ?? "Unknown Host"
//        if let note = bookmark.note, note.count > 0 {
//            noteLabel.text = note
//            stackView.addArrangedSubview(noteLabel)
//        }
//    }
    
    private func configureViews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(stackView)
        containerView.addSubview(thumbnailImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(hostLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metric.containerViewTop),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.containerViewLeading),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.containerViewTrailing),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metric.containerViewBottom),
            
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: Metric.stackViewTrailing),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Metric.stackViewBottom),
            
            thumbnailImageView.widthAnchor.constraint(equalToConstant: Metric.thumbnailImageViewWidth),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: Metric.thumbnailImageViewHeight),
            thumbnailImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.thumbnailImageViewTrailing)
        ])
    }
}
