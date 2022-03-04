//
//  BookmarkListCollectionViewCell.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/04.
//

import UIKit

final class BookmarkListCollectionViewCell: UICollectionViewCell {
    
    private var viewModel: BookmarkViewModel?
    
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
        label.preferredMaxLayoutWidth = Metric.labelWidth
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
        label.preferredMaxLayoutWidth = Metric.labelWidth
        return label
    }()
    
    @AutoLayout private var thumbnailImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.alpha = 0
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 5
        imageView.layer.cornerCurve = .continuous
        return imageView
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 16, weight: .semibold)
        static let hostLabel = UIFont.systemFont(ofSize: 14)
        static let noteLabel = UIFont.systemFont(ofSize: 14)
    }
    
    private enum Metric {
        static let labelWidth = UIScreen.main.bounds.width - (stackViewLeading + (-stackViewTrailing) + thumbnailImageViewWidth + (-thumbnailImageViewTrailing) + 40)
        
        static let stackViewTop = CGFloat(20)
        static let stackViewLeading = CGFloat(16)
        static let stackViewTrailing = CGFloat(-16)
        static let stackViewBottom = CGFloat(-20)
        
        static let thumbnailImageViewWidth = Size.thumbnail.width
        static let thumbnailImageViewHeight = Size.thumbnail.height
        static let thumbnailImageViewTrailing = CGFloat(-16)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        titleLabel.text = nil
        hostLabel.text = nil
        noteLabel.text = nil
        thumbnailImageView.image = nil
        thumbnailImageView.alpha = 0
    }
    
    static func fittingSize(with bookmarkEntity: BookmarkEntity, width: CGFloat) -> CGSize {
        let cell = BookmarkListCollectionViewCell()
        cell.configure(with: bookmarkEntity)
        let targetSize = CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)
        return cell.contentView.systemLayoutSizeFitting(targetSize,
                                                        withHorizontalFittingPriority: .required,
                                                        verticalFittingPriority: .fittingSizeLevel)
    }
    
    func configure(with bookmarkViewModel: BookmarkViewModel) {
        viewModel = bookmarkViewModel
        titleLabel.text = viewModel?.title ?? viewModel?.host ?? "Unknown Title"
        hostLabel.text = viewModel?.host ?? "Unknown Host"
        if let note = viewModel?.note, note.count > 0 {
            noteLabel.text = note
            stackView.addArrangedSubview(noteLabel)
        }
        viewModel?.bind { [weak self] thumbnail in
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = thumbnail
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2,
                                                               delay: 0,
                                                               options: .curveLinear,
                                                               animations: { self?.thumbnailImageView.alpha = 1 })
            }
        }
        viewModel?.loadThumbnail()
    }
    
    private func configureViews() {
        backgroundColor = Asset.Color.upperBackgroundColor
        layer.cornerRadius = 15
        layer.cornerCurve = .continuous
        
        contentView.addSubview(stackView)
        contentView.addSubview(thumbnailImageView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(hostLabel)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: Metric.stackViewTrailing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: Metric.stackViewBottom),
            
            thumbnailImageView.widthAnchor.constraint(equalToConstant: Metric.thumbnailImageViewWidth),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: Metric.thumbnailImageViewHeight),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: Metric.thumbnailImageViewTrailing)
        ])
    }
    
    private func configure(with bookmarkEntity: BookmarkEntity) {
        titleLabel.text = bookmarkEntity.title
        hostLabel.text = bookmarkEntity.host
        if let note = bookmarkEntity.note, note.count > 0 {
            noteLabel.text = note
            stackView.addArrangedSubview(noteLabel)
        }
    }
}
