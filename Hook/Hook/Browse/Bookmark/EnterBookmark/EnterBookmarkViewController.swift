//
//  EnterBookmarkViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs
import UIKit

protocol EnterBookmarkPresentableListener: AnyObject {
    func tagCollectionViewDidTap(existingSelectedTags: [Tag])
}

final class EnterBookmarkViewController: UIViewController, EnterBookmarkPresentable, EnterBookmarkViewControllable {
    
    private var selectedTags: [Tag] = []
    
    @AutoLayout private var headerView = SheetHeaderView(title: LocalizedString.ViewTitle.addBookmark)
    
    @AutoLayout private var tagCollectionView = LabeledTagCollectionView(title: LocalizedString.LabelTitle.tags)
    
    private enum Metric {
        static let tagCollectionViewCellHeight = CGFloat(36)
        
        static let tagCollectionViewTop = CGFloat(20)
        static let tagCollectionViewLeading = CGFloat(20)
        static let tagCollectionViewTrailing = CGFloat(-20)
    }
    
    weak var listener: EnterBookmarkPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    func update(with tags: [Tag]) {
        self.selectedTags = tags
        tagCollectionView.reloadData()
        if selectedTags.isEmpty { tagCollectionView.resetHeight() }
    }
    
    private func configureViews() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tagCollectionViewDidTap(_:)))
        tagCollectionView.addGestureRecognizer(tapGestureRecognizer)
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        view.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        view.addSubview(headerView)
        view.addSubview(tagCollectionView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            tagCollectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: Metric.tagCollectionViewTop),
            tagCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.tagCollectionViewLeading),
            tagCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.tagCollectionViewTrailing)
        ])
    }
    
    @objc
    private func tagCollectionViewDidTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == .ended { listener?.tagCollectionViewDidTap(existingSelectedTags: selectedTags) }
    }
}

extension EnterBookmarkViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LabeledTagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: selectedTags[indexPath.item])
        return cell
    }
}

extension EnterBookmarkViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return LabeledTagCollectionViewCell.fittingSize(with: selectedTags[indexPath.item],
                                                        height: Metric.tagCollectionViewCellHeight,
                                                        maximumWidth: collectionView.frame.width)
    }
}
