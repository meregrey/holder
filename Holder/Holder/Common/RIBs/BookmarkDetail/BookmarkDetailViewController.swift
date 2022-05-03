//
//  BookmarkDetailViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/11.
//

import LinkPresentation
import RIBs
import UIKit
import WebKit

protocol BookmarkDetailPresentableListener: AnyObject {
    func backwardButtonDidTap()
    func shareButtonDidTap()
    func favoriteButtonDidTap()
    func showMoreButtonDidTap()
    func didRemove()
}

final class BookmarkDetailViewController: UIViewController, BookmarkDetailPresentable, BookmarkDetailViewControllable {
    
    weak var listener: BookmarkDetailPresentableListener?
    
    private var webpageLoadCount = 0 {
        didSet {
            if webpageLoadCount > 1 { forwardButton.tintColor = Asset.Color.primaryColor }
        }
    }
    
    private var metadata: LPLinkMetadata?
    
    @AutoLayout private var webView = WKWebView(frame: .zero)
    
    private lazy var backwardButton = UIBarButtonItem(image: Image.backwardButton, style: .plain, target: self, action: #selector(backwardButtonDidTap))
    private lazy var forwardButton = UIBarButtonItem(image: Image.forwardButton, style: .plain, target: self, action: #selector(forwardButtonDidTap))
    private lazy var shareButton = UIBarButtonItem(image: Image.shareButton, style: .plain, target: self, action: #selector(shareButtonDidTap))
    private lazy var favoriteButton = UIBarButtonItem(image: Image.favoriteButton, style: .plain, target: self, action: #selector(favoriteButtonDidTap))
    private lazy var showMoreButton = UIBarButtonItem(image: Image.showMoreButton, style: .plain, target: self, action: #selector(showMoreButtonDidTap))
    private lazy var fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
    private lazy var flexibleSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    
    private enum Image {
        static let backwardButton = UIImage(systemName: "chevron.left")
        static let forwardButton = UIImage(systemName: "chevron.right")
        static let shareButton = UIImage(systemName: "square.and.arrow.up")
        static let favoriteButton = UIImage(systemName: "bookmark")
        static let showMoreButton = UIImage(systemName: "ellipsis")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isToolbarHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == #keyPath(WKWebView.url) else { return }
        webpageLoadCount += 1
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    func load(from url: URL) {
        webView.load(URLRequest(url: url))
    }
    
    func updateToolbar(for isFavorite: Bool) {
        let image = isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        favoriteButton.image = image
    }
    
    func displayShareSheet(with metadata: LPLinkMetadata) {
        self.metadata = metadata
        let activityViewController = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        DispatchQueue.main.async {
            self.present(activityViewController, animated: true)
        }
    }
    
    func reload() {
        webView.reload()
    }
    
    func displayAlert(title: String, message: String?, action: Action?) {
        presentAlert(title: title, message: message, action: action)
    }
    
    func dismiss(_ completion: @escaping () -> Void) {
        dismiss(animated: true, completion: completion)
    }
    
    private func configureViews() {
        webView.scrollView.delegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil)
        
        fixedSpaceItem.width = 7
        forwardButton.tintColor = Asset.Color.secondaryColor
        toolbarItems = [fixedSpaceItem, backwardButton, flexibleSpaceItem, fixedSpaceItem, forwardButton, fixedSpaceItem, flexibleSpaceItem, shareButton, flexibleSpaceItem, favoriteButton, flexibleSpaceItem, showMoreButton, fixedSpaceItem]
        
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.webViewBackgroundColor
        view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func backwardButtonDidTap() {
        if webView.canGoBack {
            webView.goBack()
            return
        }
        listener?.backwardButtonDidTap()
    }
    
    @objc
    private func forwardButtonDidTap() {
        if webView.canGoForward { webView.goForward() }
    }
    
    @objc
    private func shareButtonDidTap() {
        listener?.shareButtonDidTap()
    }
    
    @objc
    private func favoriteButtonDidTap() {
        listener?.favoriteButtonDidTap()
    }
    
    @objc
    private func showMoreButtonDidTap() {
        listener?.showMoreButtonDidTap()
    }
}

extension BookmarkDetailViewController: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.navigationController?.setToolbarHidden(velocity.y >= 0, animated: true)
        }
    }
}

extension BookmarkDetailViewController: UIActivityItemSource {
    
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
