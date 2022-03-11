//
//  BookmarkBrowserViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import LinkPresentation
import RIBs
import UIKit

protocol BookmarkBrowserPresentableListener: AnyObject {
    func indexPathDidChange(indexPath: IndexPath)
    func addBookmarkButtonDidTap()
}

final class BookmarkBrowserViewController: UIViewController, BookmarkBrowserPresentable, BookmarkBrowserViewControllable {
    
    private var tags: [Tag] = []
    private var currentIndexPath = IndexPath(item: 0, section: 0)
    private var bookmarkListCollectionViewContentOffsets: [IndexPath: CGPoint] = [:]
    private var metadata: LPLinkMetadata?
    
    private var bookmarkListCollectionViewListener: BookmarkListCollectionViewListener? { listener as? BookmarkListCollectionViewListener }
    
    @AutoLayout private var bookmarkBrowserCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.minimumLineSpacing = .zero
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(BookmarkBrowserCollectionViewCell.self)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = .clear
        
        return collectionView
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
        static let addBookmarkButtonWidth = CGFloat(80)
        static let addBookmarkButtonHeight = CGFloat(50)
        static let addBookmarkButtonBottom = CGFloat(-20)
    }
    
    weak var listener: BookmarkBrowserPresentableListener?
    
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
    }
    
    func update(with currentTag: Tag) {
        guard let index = tags.firstIndex(of: currentTag) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        bookmarkBrowserCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
    
    func displayShareSheet(with metadata: LPLinkMetadata) {
        self.metadata = metadata
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true)
        }
    }
    
    func displayAlert(title: String, message: String?, action: AlertAction?) {
        presentAlert(title: title, message: message, action: action)
    }
    
    private func configureViews() {
        bookmarkBrowserCollectionView.dataSource = self
        bookmarkBrowserCollectionView.delegate = self
        
        view.addSubview(bookmarkBrowserCollectionView)
        view.addSubview(addBookmarkButton)
        
        NSLayoutConstraint.activate([
            bookmarkBrowserCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            bookmarkBrowserCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkBrowserCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarkBrowserCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addBookmarkButton.widthAnchor.constraint(equalToConstant: Metric.addBookmarkButtonWidth),
            addBookmarkButton.heightAnchor.constraint(equalToConstant: Metric.addBookmarkButtonHeight),
            addBookmarkButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addBookmarkButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.addBookmarkButtonBottom)
        ])
    }
    
    @objc
    private func addBookmarkButtonDidTap() {
        listener?.addBookmarkButtonDidTap()
    }
}

// MARK: - Data Source

extension BookmarkBrowserViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookmarkBrowserCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let tag = tags[indexPath.item]
        cell.configure(with: tag, listener: bookmarkListCollectionViewListener)
        return cell
    }
}

// MARK: - Delegate

extension BookmarkBrowserViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? BookmarkBrowserCollectionViewCell else { return }
        let contentOffset = bookmarkListCollectionViewContentOffsets[indexPath] ?? CGPoint.zero
        cell.setBookmarkListCollectionViewContentOffset(contentOffset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? BookmarkBrowserCollectionViewCell else { return }
        cell.resetBookmarkListCollectionViewContentOffset()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard let cell = collectionView.cellForItem(at: currentIndexPath) as? BookmarkBrowserCollectionViewCell else { return }
        let contentOffset = cell.bookmarkListCollectionViewContentOffset()
        bookmarkListCollectionViewContentOffsets.updateValue(contentOffset, forKey: currentIndexPath)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        guard let indexPath = collectionView.indexPathsForVisibleItems.first else { return }
        currentIndexPath = indexPath
        listener?.indexPathDidChange(indexPath: indexPath)
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
