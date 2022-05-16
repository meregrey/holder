//
//  BookmarkBrowserViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import LinkPresentation
import RIBs
import UIKit

protocol BookmarkBrowserPresentableListener: AnyObject {
    func indexPathDidChange(pendingTag: Tag?)
    func addBookmarkButtonDidTap()
}

final class BookmarkBrowserViewController: UIViewController, BookmarkBrowserPresentable, BookmarkBrowserViewControllable {
    
    weak var listener: BookmarkBrowserPresentableListener?
    
    private var tags: [Tag] = []
    private var currentIndexPath = IndexPath(item: 0, section: 0)
    private var lastContentOffset = CGPoint(x: 0, y: 0)
    private var contentOffsetsForBookmarkListCollectionView: [IndexPath: CGPoint] = [:]
    private var metadata: LPLinkMetadata?
    private var bookmarkListCollectionViewListener: BookmarkListCollectionViewListener? { listener as? BookmarkListCollectionViewListener }
    
    @AutoLayout private var bookmarkBrowserCollectionView = BookmarkBrowserCollectionView()
    
    @AutoLayout private var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .prominent)
        let view = UIVisualEffectView(effect: effect)
        view.alpha = 0
        return view
    }()
    
    @AutoLayout private var addBookmarkButton: UIButton = {
        let button = UIButton()
        button.setTitle(LocalizedString.ActionTitle.add, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.titleLabel?.font = Font.addBookmarkButton
        button.backgroundColor = Asset.Color.primaryColor
        button.layer.cornerRadius = Metric.addBookmarkButtonHeight / 2
        button.addTarget(self, action: #selector(addBookmarkButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private enum Font {
        static let addBookmarkButton = UIFont.systemFont(ofSize: 16, weight: .semibold)
    }
    
    private enum Metric {
        static let blurViewHeight = Size.safeAreaTopInset + Size.tagBarHeight
        
        static let addBookmarkButtonWidth = CGFloat(80)
        static let addBookmarkButtonHeight = CGFloat(50)
        static let addBookmarkButtonBottom = CGFloat(-20)
    }
    
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
        bookmarkBrowserCollectionView.reloadData()
        bookmarkBrowserCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
    }
    
    func update(with currentTag: Tag) {
        let indexForTag = (tags.firstIndex(of: currentTag) ?? 0) + 1
        let index = currentTag.name == TagName.all ? 0 : indexForTag
        let indexPath = IndexPath(item: index, section: 0)
        bookmarkBrowserCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    func displayBlurView(for contentOffset: CGPoint) {
        var alpha = 0
        if contentOffset.y > -(Size.safeAreaTopInset) { alpha = 1 }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.blurView.alpha = CGFloat(alpha)
        }
    }
    
    func displayShareSheet(with metadata: LPLinkMetadata) {
        self.metadata = metadata
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true)
        }
    }
    
    func displayAlert(title: String, message: String?, action: Action?) {
        presentAlert(title: title, message: message, action: action)
    }
    
    private func configureViews() {
        bookmarkBrowserCollectionView.dataSource = self
        bookmarkBrowserCollectionView.delegate = self
        
        view.addSubview(bookmarkBrowserCollectionView)
        view.addSubview(blurView)
        view.addSubview(addBookmarkButton)
        
        NSLayoutConstraint.activate([
            bookmarkBrowserCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            bookmarkBrowserCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkBrowserCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarkBrowserCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blurView.heightAnchor.constraint(equalToConstant: Metric.blurViewHeight),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            addBookmarkButton.widthAnchor.constraint(equalToConstant: Metric.addBookmarkButtonWidth),
            addBookmarkButton.heightAnchor.constraint(equalToConstant: Metric.addBookmarkButtonHeight),
            addBookmarkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addBookmarkButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.addBookmarkButtonBottom)
        ])
    }
    
    private func indexPathForVisibleItem(of collectionView: UICollectionView) -> IndexPath {
        let indexPathsForVisibleItems = collectionView.indexPathsForVisibleItems
        let defaultIndexPath = IndexPath(item: 0, section: 0)
        
        guard indexPathsForVisibleItems.count > 1 else { return indexPathsForVisibleItems.first ?? defaultIndexPath }
        
        if lastContentOffset.x < collectionView.contentOffset.x {
            return indexPathsForVisibleItems.max(by: { $0.item < $1.item }) ?? defaultIndexPath
        } else {
            return indexPathsForVisibleItems.min(by: { $0.item < $1.item }) ?? defaultIndexPath
        }
    }
    
    @objc
    private func addBookmarkButtonDidTap() {
        listener?.addBookmarkButtonDidTap()
    }
}

// MARK: - Data Source

extension BookmarkBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookmarkBrowserCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let tag = indexPath.item > 0 ? tags[indexPath.item - 1] : nil
        cell.configure(listener: bookmarkListCollectionViewListener, tag: tag)
        return cell
    }
}

// MARK: - Delegate

extension BookmarkBrowserViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? BookmarkBrowserCollectionViewCell else { return }
        guard let contentOffset = contentOffsetsForBookmarkListCollectionView[indexPath] else { return }
        cell.setContentOffsetForBookmarkListCollectionView(contentOffset)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard let cell = collectionView.cellForItem(at: currentIndexPath) as? BookmarkBrowserCollectionViewCell else { return }
        let contentOffset = cell.contentOffsetForBookmarkListCollectionView()
        contentOffsetsForBookmarkListCollectionView.updateValue(contentOffset, forKey: currentIndexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        let indexPath = indexPathForVisibleItem(of: collectionView)
        let pendingTag = indexPath.item > 0 ? tags[indexPath.item - 1] : nil
        listener?.indexPathDidChange(pendingTag: pendingTag)
        currentIndexPath = indexPath
        lastContentOffset = collectionView.contentOffset
        if let contentOffset = contentOffsetsForBookmarkListCollectionView[indexPath] { displayBlurView(for: contentOffset) }
    }
}

// MARK: - Layout

extension BookmarkBrowserViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
}

// MARK: - Share

extension BookmarkBrowserViewController: UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return metadata?.originalURL
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        return metadata
    }
}

