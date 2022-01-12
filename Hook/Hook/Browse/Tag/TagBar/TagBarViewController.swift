//
//  TagBarViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs
import RxSwift
import UIKit

protocol TagBarPresentableListener: AnyObject {
    func tagSettingsButtonDidTap()
}

final class TagBarViewController: UIViewController, TagBarPresentable, TagBarViewControllable {
    
    private var tags: [Tag] = []
    
    @AutoLayout private var containerView = UIView()
    
    @AutoLayout private var tagBarCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(TagBarCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    @AutoLayout private var tagSettingsButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.tagSettingsButton, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = Color.tagSettingsButton
        button.addTarget(self, action: #selector(tagSettingsButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private enum Image {
        static let tagSettingsButton = UIImage(systemName: "ellipsis")
    }
    
    private enum Color {
        static let tagSettingsButton = UIColor.black
    }
    
    private enum Metric {
        static let containerViewHeight = CGFloat(60)
        static let tagBarCollectionViewHeight = containerViewHeight
        static let tagBarCollectionViewLeading = CGFloat(10)
        static let tagBarCollectionViewTrailing = CGFloat(-10)
        static let tagSettingsButtonWidthHeight = CGFloat(26)
        static let tagSettingsButtonTrailing = CGFloat(-20)
    }
    
    weak var listener: TagBarPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func update(with tags: [Tag]) {
        self.tags = tags
        tagBarCollectionView.reloadData()
    }
    
    private func configureViews() {
        tagBarCollectionView.dataSource = self
        tagBarCollectionView.delegate = self
        
        view.addSubview(containerView)
        containerView.addSubview(tagBarCollectionView)
        containerView.addSubview(tagSettingsButton)
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerView.heightAnchor.constraint(equalToConstant: Metric.containerViewHeight),
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tagBarCollectionView.heightAnchor.constraint(equalToConstant: Metric.tagBarCollectionViewHeight),
            tagBarCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.tagBarCollectionViewLeading),
            tagBarCollectionView.trailingAnchor.constraint(equalTo: tagSettingsButton.leadingAnchor, constant: Metric.tagBarCollectionViewTrailing),
            tagBarCollectionView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            
            tagSettingsButton.widthAnchor.constraint(equalToConstant: Metric.tagSettingsButtonWidthHeight),
            tagSettingsButton.heightAnchor.constraint(equalToConstant: Metric.tagSettingsButtonWidthHeight),
            tagSettingsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.tagSettingsButtonTrailing),
            tagSettingsButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    @objc private func tagSettingsButtonDidTap() {
        listener?.tagSettingsButtonDidTap()
    }
}

extension TagBarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagBarCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: tags[indexPath.item])
        return cell
    }
}

extension TagBarViewController: UICollectionViewDelegate {}

extension TagBarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return TagBarCollectionViewCell.fittingSize(withTag: tags[indexPath.item], height: Metric.containerViewHeight)
    }
}
