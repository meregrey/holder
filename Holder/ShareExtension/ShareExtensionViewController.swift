//
//  ShareExtensionViewController.swift
//  ShareExtension
//
//  Created by Yeojin Yoon on 2022/04/15.
//

import RIBs
import UIKit

protocol ShareViewControllerListener: AnyObject {
    var viewController: ShareViewControllable? { get set }
    func tagCollectionViewDidTap(existingSelectedTags: [Tag])
    func saveButtonDidTap(bookmark: Bookmark)
}

final class ShareExtensionViewController: UIViewController, ShareViewControllable, ShareListener {
    
    weak var listener: ShareViewControllerListener?
    
    private let typeIdentifier = "public.url"
    
    private var selectedTags: [Tag] = []
    
    private var router: ShareRouting? {
        didSet {
            listener = router?.interactable as? ShareViewControllerListener
            listener?.viewController = self
        }
    }
    
    @AutoLayout private var navigationBar = SingleButtonNavigationBar(title: LocalizedString.appDisplayName)
    
    @AutoLayout private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    @AutoLayout private var linkTextField = LabeledLinkTextField(header: LocalizedString.LabelText.link)
    
    @AutoLayout private var tagCollectionView = LabeledTagCollectionView(header: LocalizedString.LabelText.tags)
    
    @AutoLayout private var noteTextView = LabeledNoteTextView(header: LocalizedString.LabelText.note)
    
    @AutoLayout private var transparentFooterView = UIView()
    
    @AutoLayout private var saveButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ActionTitle.save, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.backgroundColor = Asset.Color.primaryColor
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    @AutoLayout private var explanationView: ShareExtensionExplanationView = {
        let view = ShareExtensionExplanationView()
        view.isHidden = true
        return view
    }()
    
    private lazy var originalViewFrame = view.frame
    
    private lazy var saveButtonBottomConstraint = NSLayoutConstraint(item: saveButton,
                                                                     attribute: .bottom,
                                                                     relatedBy: .equal,
                                                                     toItem: view,
                                                                     attribute: .bottom,
                                                                     multiplier: 1,
                                                                     constant: Metric.saveButtonBottom)
    
    private enum Metric {
        static let linkTextFieldTop = CGFloat(10)
        static let linkTextFieldLeading = CGFloat(20)
        static let linkTextFieldTrailing = CGFloat(-20)
        
        static let tagCollectionViewCellHeight = CGFloat(36)
        static let tagCollectionViewTop = CGFloat(30)
        static let tagCollectionViewLeading = CGFloat(20)
        static let tagCollectionViewTrailing = CGFloat(-20)
        
        static let noteTextViewTop = CGFloat(30)
        static let noteTextViewLeading = CGFloat(20)
        static let noteTextViewTrailing = CGFloat(-20)
        static let noteTextViewBottom = CGFloat(-20)
        
        static let transparentFooterViewHeight = CGFloat(100)
        
        static let saveButtonLeading = CGFloat(20)
        static let saveButtonTrailing = CGFloat(-20)
        static let saveButtonBottom = CGFloat(-40)
        static let saveButtonBottomForKeyboard = CGFloat(-20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activateRIB()
        loadURL()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        deactivateRIB()
    }
    
    func update(with selectedTags: [Tag]) {
        self.selectedTags = selectedTags
        tagCollectionView.reloadData()
        if selectedTags.isEmpty { tagCollectionView.resetHeight() }
    }
    
    func completeRequest() {
        extensionContext?.completeRequest(returningItems: nil)
    }
    
    private func activateRIB() {
        let component = ShareExtensionComponent(baseViewController: self)
        let builder = ShareBuilder(dependency: component)
        let router = builder.build(withListener: self)
        self.router = router
        self.router?.interactable.activate()
    }
    
    private func loadURL() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem else { return }
        guard let itemProvider = item.attachments?.first, itemProvider.hasItemConformingToTypeIdentifier(typeIdentifier) else { return }
        itemProvider.loadItem(forTypeIdentifier: typeIdentifier) { [weak self] item, _ in
            guard let url = item as? URL else { return }
            self?.validateURL(url)
        }
    }
    
    private func validateURL(_ url: URL) {
        let result = BookmarkRepository.shared.isExisting(url)
        switch result {
        case .success(let isExisting):
            DispatchQueue.main.async {
                isExisting ? self.displayForExplanation() : self.displayForInput(with: url)
            }
        case .failure(_): break
        }
    }
    
    private func displayForInput(with url: URL) {
        linkTextField.setText(url.absoluteString)
        linkTextField.disable(includingTransparency: false)
        registerToReceiveNotification()
        configureViews()
    }
    
    private func displayForExplanation() {
        explanationView.isHidden = false
        configureViews()
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillShow(_:)),
                                       name: UIResponder.keyboardWillShowNotification)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(keyboardWillHide),
                                       name: UIResponder.keyboardWillHideNotification)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo else { return }
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        saveButtonBottomConstraint.constant = Metric.saveButtonBottomForKeyboard
        view.frame = CGRect(x: originalViewFrame.origin.x, y: originalViewFrame.origin.y, width: originalViewFrame.width, height: originalViewFrame.height - keyboardFrame.height)
        view.layoutIfNeeded()
    }
    
    @objc
    private func keyboardWillHide() {
        saveButtonBottomConstraint.constant = Metric.saveButtonBottom
        view.frame = CGRect(x: originalViewFrame.origin.x, y: originalViewFrame.origin.y, width: originalViewFrame.width, height: originalViewFrame.height)
        view.layoutIfNeeded()
    }
    
    private func configureViews() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tagCollectionViewDidTap(_:)))
        tagCollectionView.addGestureRecognizer(tapGestureRecognizer)
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        navigationBar.listener = self
        scrollView.delegate = self
        linkTextField.listener = self
        noteTextView.listener = self
        explanationView.listener = self
        
        view.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        view.addSubview(navigationBar)
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        view.addSubview(explanationView)
        
        scrollView.addSubview(linkTextField)
        scrollView.addSubview(tagCollectionView)
        scrollView.addSubview(noteTextView)
        scrollView.addSubview(transparentFooterView)
        
        saveButtonBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            
            linkTextField.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Metric.linkTextFieldTop),
            linkTextField.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.linkTextFieldLeading),
            linkTextField.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.linkTextFieldTrailing),
            
            tagCollectionView.topAnchor.constraint(equalTo: linkTextField.bottomAnchor, constant: Metric.tagCollectionViewTop),
            tagCollectionView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.tagCollectionViewLeading),
            tagCollectionView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.tagCollectionViewTrailing),
            
            noteTextView.topAnchor.constraint(equalTo: tagCollectionView.bottomAnchor, constant: Metric.noteTextViewTop),
            noteTextView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.noteTextViewLeading),
            noteTextView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.noteTextViewTrailing),
            
            transparentFooterView.heightAnchor.constraint(equalToConstant: Metric.transparentFooterViewHeight),
            transparentFooterView.topAnchor.constraint(equalTo: noteTextView.bottomAnchor),
            transparentFooterView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            transparentFooterView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            transparentFooterView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.saveButtonLeading),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.saveButtonTrailing),
            
            explanationView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            explanationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            explanationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            explanationView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc
    private func tagCollectionViewDidTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == .ended {
            listener?.tagCollectionViewDidTap(existingSelectedTags: selectedTags)
        }
    }
    
    @objc
    private func saveButtonDidTap() {
        guard let urlString = linkTextField.text, let url = URL(string: urlString) else { return }
        let tags = selectedTags.count > 0 ? selectedTags : nil
        let note = noteTextView.text
        let bookmark = Bookmark(url: url, tags: tags, note: note, title: nil)
        listener?.saveButtonDidTap(bookmark: bookmark)
    }
    
    private func scrollToTop() {
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    private func scrollToBottom() {
        let offset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.height)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    private func deactivateRIB() {
        router?.interactable.deactivate()
    }
}

// MARK: - Navigation Bar

extension ShareExtensionViewController: SingleButtonNavigationBarListener {
    
    func cancelButtonDidTap() {
        extensionContext?.completeRequest(returningItems: nil)
    }
}

// MARK: - Scroll View

extension ShareExtensionViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - Text Field

extension ShareExtensionViewController: LabeledLinkTextFieldListener {
    
    func textFieldDidBecomeFirstResponder() {
        scrollToTop()
    }
}

// MARK: - Collection View

extension ShareExtensionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: LabeledTagCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        cell.configure(with: selectedTags[indexPath.item])
        return cell
    }
}

extension ShareExtensionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return LabeledTagCollectionViewCell.fittingSize(with: selectedTags[indexPath.item],
                                                        height: Metric.tagCollectionViewCellHeight,
                                                        maximumWidth: collectionView.frame.width)
    }
}

// MARK: - Text View

extension ShareExtensionViewController: LabeledNoteTextViewListener {
    
    func textViewDidBecomeFirstResponder() {
        scrollToBottom()
    }
    
    func textViewHeightDidIncrease() {
        scrollToBottom()
    }
}

// MARK: - Explanation View

extension ShareExtensionViewController: ShareExtensionExplanationViewListener {
    
    func okButtonDidTap() {
        extensionContext?.completeRequest(returningItems: nil)
    }
}
