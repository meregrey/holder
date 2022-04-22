//
//  LabeledTagCollectionView.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/02/04.
//

import UIKit

final class LabeledTagCollectionView: LabeledView {
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView(cornerRadius: Metric.containerViewCornerRadius)
        view.backgroundColor = Asset.Color.sheetUpperBackgroundColor
        return view
    }()
    
    @AutoLayout private var tagCollectionView: LeftAlignmentCollectionView = {
        let collectionView = LeftAlignmentCollectionView()
        collectionView.register(LabeledTagCollectionViewCell.self)
        return collectionView
    }()
    
    @AutoLayout private var downImageView: UIImageView = {
        let imageView = UIImageView(image: Image.down)
        imageView.tintColor = Asset.Color.secondaryColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var containerViewHeightConstraint = NSLayoutConstraint(item: containerView,
                                                                        attribute: .height,
                                                                        relatedBy: .equal,
                                                                        toItem: nil,
                                                                        attribute: .notAnAttribute,
                                                                        multiplier: 1,
                                                                        constant: 60)
    
    private enum Image {
        static let down = UIImage(systemName: "chevron.down", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
    }
    
    private enum Metric {
        static let containerViewCornerRadius = CGFloat(12)
        static let containerViewMinimumHeight = CGFloat(60)
        
        static let tagCollectionViewTop = CGFloat(12)
        static let tagCollectionViewLeading = CGFloat(16)
        static let tagCollectionViewTrailing = CGFloat(-12)
        static let tagCollectionViewBottom = CGFloat(-12)
        
        static let downImageViewWidthHeight = CGFloat(20)
        static let downImageViewTop = CGFloat(20)
        static let downImageViewTrailing = CGFloat(-16)
    }
    
    weak var dataSource: UICollectionViewDataSource? {
        didSet { tagCollectionView.dataSource = dataSource }
    }
    
    weak var delegate: UICollectionViewDelegate? {
        didSet { tagCollectionView.delegate = delegate }
    }
    
    init(header: String) {
        super.init(header: header, theme: .sheet)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        containerView.addGestureRecognizer(gestureRecognizer)
    }
    
    func reloadData() {
        DispatchQueue.main.async {
            self.tagCollectionView.reloadData()
        }
    }
    
    func resetHeight() {
        DispatchQueue.main.async {
            self.containerViewHeightConstraint.constant = Metric.containerViewMinimumHeight
            self.layoutIfNeeded()
        }
    }
    
    private func configureViews() {
        tagCollectionView.listener = self
        
        containerView.addConstraint(containerViewHeightConstraint)
        containerView.addSubview(tagCollectionView)
        containerView.addSubview(downImageView)
        addSubviewUnderLabel(containerView)
        
        NSLayoutConstraint.activate([
            tagCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metric.tagCollectionViewTop),
            tagCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.tagCollectionViewLeading),
            tagCollectionView.trailingAnchor.constraint(equalTo: downImageView.leadingAnchor, constant: Metric.tagCollectionViewTrailing),
            tagCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Metric.tagCollectionViewBottom),
            
            downImageView.widthAnchor.constraint(equalToConstant: Metric.downImageViewWidthHeight),
            downImageView.heightAnchor.constraint(equalToConstant: Metric.downImageViewWidthHeight),
            downImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Metric.downImageViewTop),
            downImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.downImageViewTrailing)
        ])
    }
}

extension LabeledTagCollectionView: LeftAlignmentCollectionViewListener {
    
    func maxYDidSet(_ maxY: CGFloat) {
        guard maxY > 0 else { return }
        let height = maxY + Metric.tagCollectionViewTop * 2
        containerViewHeightConstraint.constant = height
        layoutIfNeeded()
    }
}
