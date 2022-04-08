//
//  TagBarViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import CoreData
import RIBs
import UIKit

protocol TagBarPresentableListener: AnyObject {
    func tagDidSelect(tag: Tag)
    func tagSettingsButtonDidTap()
}

final class TagBarViewController: UIViewController, TagBarPresentable, TagBarViewControllable {
    
    private var currentIndexPath = IndexPath(item: 0, section: 0)
    private var fetchedResultsController: NSFetchedResultsController<TagEntity>?
    
    @AutoLayout private var containerView = UIView()
    
    @AutoLayout private var tagBarCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(TagBarCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
    }()
    
    @AutoLayout private var tagSettingsButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.tagSettingsButton, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = Asset.Color.primaryColor
        button.addTarget(self, action: #selector(tagSettingsButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private enum Image {
        static let tagSettingsButton = UIImage(systemName: "ellipsis")
    }
    
    private enum Metric {
        static let containerViewHeight = Size.safeAreaTopInset + Size.tagBarHeight
        
        static let tagBarCollectionViewHeight = Size.tagBarHeight
        static let tagBarCollectionViewLeading = CGFloat(10)
        static let tagBarCollectionViewTrailing = CGFloat(-16)
        
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
    
    func update(with fetchedResultsController: NSFetchedResultsController<TagEntity>) {
        self.fetchedResultsController = fetchedResultsController
        self.fetchedResultsController?.delegate = self
        DispatchQueue.main.async {
            self.tagBarCollectionView.reloadData()
            self.tagBarCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
        }
    }
    
    func update(with currentTag: Tag) {
        let indexPath: IndexPath
        
        if currentTag.name == TagName.all {
            indexPath = IndexPath(item: 0, section: 0)
        } else {
            guard let tagEntities = fetchedResultsController?.fetchedObjects else { return }
            guard let tagEntity = tagEntities.filter({ $0.name == currentTag.name }).first else { return }
            indexPath = IndexPath(item: Int(tagEntity.index) + 1, section: 0)
        }
        
        DispatchQueue.main.async {
            self.tagBarCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
            self.currentIndexPath = indexPath
        }
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
            tagBarCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            tagSettingsButton.widthAnchor.constraint(equalToConstant: Metric.tagSettingsButtonWidthHeight),
            tagSettingsButton.heightAnchor.constraint(equalToConstant: Metric.tagSettingsButtonWidthHeight),
            tagSettingsButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.tagSettingsButtonTrailing),
            tagSettingsButton.centerYAnchor.constraint(equalTo: tagBarCollectionView.centerYAnchor)
        ])
    }
    
    @objc
    private func tagSettingsButtonDidTap() {
        listener?.tagSettingsButtonDidTap()
    }
}

// MARK: - Data Source

extension TagBarViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let fetchedObjectsCount = fetchedResultsController?.fetchedObjects?.count ?? 0
        return fetchedObjectsCount + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TagBarCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        if fetchedResultsController == nil || indexPath.item == 0 {
            cell.configure(with: Tag(name: TagName.all))
            return cell
        } else {
            guard let tagEntity = fetchedResultsController?.fetchedObjects?[indexPath.item - 1] else { return cell }
            cell.configure(with: Tag(name: tagEntity.name))
            return cell
        }
    }
}

// MARK: - Delegate

extension TagBarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tag: Tag
        if fetchedResultsController == nil || indexPath.item == 0 {
            tag = Tag(name: TagName.all)
        } else {
            guard let tagEntity = fetchedResultsController?.fetchedObjects?[indexPath.item - 1] else { return }
            tag = Tag(name: tagEntity.name)
        }
        listener?.tagDidSelect(tag: tag)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - Layout

extension TagBarViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        if fetchedResultsController == nil || indexPath.item == 0 {
            return TagBarCollectionViewCell.fittingSize(with: Tag(name: TagName.all), height: Metric.tagBarCollectionViewHeight)
        } else {
            guard let tagEntity = fetchedResultsController?.fetchedObjects?[indexPath.item - 1] else { return CGSize(width: 0, height: 0) }
            return TagBarCollectionViewCell.fittingSize(with: Tag(name: tagEntity.name), height: Metric.tagBarCollectionViewHeight)
        }
    }
}

// MARK: - Fetched Results Controller Delegate

extension TagBarViewController: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tagBarCollectionView.reloadData()
        tagBarCollectionView.selectItem(at: currentIndexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
}
