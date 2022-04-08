//
//  BookmarkListViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/23.
//

import CoreData
import LinkPresentation
import RIBs
import UIKit

protocol BookmarkListPresentableListener: AnyObject {}

final class BookmarkListViewController: UIViewController, BookmarkListPresentable, BookmarkListViewControllable {
    
    private let isForFavorites: Bool
    
    private var metadata: LPLinkMetadata?
    
    @AutoLayout private var bookmarkListCollectionView = BookmarkListCollectionView()
    
    @AutoLayout private var blurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .prominent)
        let view = UIVisualEffectView(effect: effect)
        view.alpha = 0
        return view
    }()
    
    @AutoLayout private var explanationView = ExplanationView()
    
    private weak var fetchedResultsController: NSFetchedResultsController<BookmarkEntity>? {
        didSet { fetchedResultsController?.delegate = fetchedResultsControllerDelegate }
    }
    
    private weak var bookmarkListCollectionViewListener: BookmarkListCollectionViewListener? { listener as? BookmarkListCollectionViewListener }
    private lazy var fetchedResultsControllerDelegate = FetchedResultsControllerDelegate(collectionView: bookmarkListCollectionView)
    private lazy var bookmarkListContextMenuProvider = BookmarkListContextMenuProvider(listener: bookmarkListCollectionViewListener)
    
    private enum Metric {
        static let blurViewHeight = Size.searchBarViewHeight
    }
    
    weak var listener: BookmarkListPresentableListener?
    
    init(forFavorites isForFavorites: Bool) {
        self.isForFavorites = isForFavorites
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        self.isForFavorites = false
        super.init(coder: coder)
        configureViews()
    }
    
    func update(fetchedResultsController: NSFetchedResultsController<BookmarkEntity>?, searchTerm: String) {
        self.fetchedResultsController = fetchedResultsController
        DispatchQueue.main.async {
            if let fetchedObjects = fetchedResultsController?.fetchedObjects, fetchedObjects.count > 0 {
                self.bookmarkListCollectionView.reloadData()
                self.explanationView.isHidden = true
            } else {
                self.configureExplanationView(with: searchTerm)
                self.explanationView.isHidden = false
            }
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
    
    func push(_ view: ViewControllable) {
        navigationController?.pushViewController(view.uiviewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureViews() {
        bookmarkListCollectionView.dataSource = self
        bookmarkListCollectionView.prefetchDataSource = self
        bookmarkListCollectionView.delegate = self
        
        view.addSubview(bookmarkListCollectionView)
        view.addSubview(blurView)
        view.addSubview(explanationView)
        
        NSLayoutConstraint.activate([
            bookmarkListCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            bookmarkListCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bookmarkListCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bookmarkListCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blurView.heightAnchor.constraint(equalToConstant: Metric.blurViewHeight),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            explanationView.topAnchor.constraint(equalTo: view.topAnchor),
            explanationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            explanationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            explanationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureExplanationView(with searchTerm: String) {
        let title = searchTerm.count > 0 ? LocalizedString.LabelText.noSearchResults : LocalizedString.LabelText.noFavorites
        let explanation = searchTerm.count > 0 ? LocalizedString.LabelText.noSearchResultsExplanation : LocalizedString.LabelText.noFavoritesExplanation
        explanationView.setTitle(title)
        explanationView.setExplanation(explanation)
    }
    
    private func bookmarkEntity(at indexPath: IndexPath) -> BookmarkEntity? {
        return fetchedResultsController?.object(at: indexPath)
    }
    
    private func displayBlurView(for contentOffset: CGPoint) {
        var alpha = 0
        if contentOffset.y > -(Size.safeAreaTopInset) { alpha = 1 }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.blurView.alpha = CGFloat(alpha)
        }
    }
}

// MARK: - Data Source

extension BookmarkListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let fetchedObjects = fetchedResultsController?.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: BookmarkListCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        guard let bookmarkEntity = bookmarkEntity(at: indexPath) else { return cell }
        let viewModel = BookmarkViewModel(with: bookmarkEntity)
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                               withReuseIdentifier: String(describing: UICollectionReusableView.self),
                                                               for: indexPath)
    }
}

// MARK: - Prefetching

extension BookmarkListViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach {
            guard let bookmarkEntity = bookmarkEntity(at: $0) else { return }
            guard let url = URL(string: bookmarkEntity.urlString) else { return }
            ThumbnailLoader.shared.loadThumbnail(for: url) { _ in }
        }
    }
}

// MARK: - Delegate

extension BookmarkListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let bookmarkEntity = bookmarkEntity(at: indexPath) else { return }
        bookmarkListCollectionViewListener?.bookmarkDidTap(bookmarkEntity: bookmarkEntity)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let bookmarkEntity = self.bookmarkEntity(at: indexPath)
            return self.bookmarkListContextMenuProvider.menu(for: bookmarkEntity)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let collectionView = scrollView as? UICollectionView else { return }
        displayBlurView(for: collectionView.contentOffset)
    }
}

// MARK: - Layout

extension BookmarkListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let defaultHeight = CGFloat(84)
        let defaultSize = CGSize(width: collectionView.frame.width - 40, height: defaultHeight)
        guard let bookmarkEntity = bookmarkEntity(at: indexPath) else { return defaultSize }
        let fittingSize = BookmarkListCollectionViewCell.fittingSize(with: bookmarkEntity, width: defaultSize.width)
        return fittingSize.height > defaultHeight ? fittingSize : defaultSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.frame.width
        let height = Size.searchBarViewHeight - Size.safeAreaTopInset
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 10)
    }
}

// MARK: - Share

extension BookmarkListViewController: UIActivityItemSource {
    
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
