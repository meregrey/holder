//
//  EnterBookmarkViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs
import UIKit

protocol EnterBookmarkPresentableListener: AnyObject {
    func closeButtonDidTap()
    func tagCollectionViewDidTap(existingSelectedTags: [Tag])
    func saveButtonDidTap(url: URL, tags: [Tag]?, note: String?)
}

final class EnterBookmarkViewController: UIViewController, EnterBookmarkPresentable, EnterBookmarkViewControllable {
    
    private var selectedTags: [Tag] = []
    
    @AutoLayout private var headerView = SheetHeaderView(title: LocalizedString.ViewTitle.addBookmark)
    
    @AutoLayout private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    @AutoLayout private var urlTextField = LabeledURLTextField(header: "URL")
    
    @AutoLayout private var tagCollectionView = LabeledTagCollectionView(header: LocalizedString.LabelTitle.tags)
    
    @AutoLayout private var noteTextView = LabeledNoteTextView(header: LocalizedString.LabelTitle.note)
    
    @AutoLayout private var transparentFooterView = UIView()
    
    @AutoLayout private var saveButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ButtonTitle.save, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.backgroundColor = Asset.Color.primaryColor
        button.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        return button
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
        static let urlTextFieldTop = CGFloat(10)
        static let urlTextFieldLeading = CGFloat(20)
        static let urlTextFieldTrailing = CGFloat(-20)
        
        static let tagCollectionViewCellHeight = CGFloat(36)
        static let tagCollectionViewTop = CGFloat(30)
        static let tagCollectionViewLeading = CGFloat(20)
        static let tagCollectionViewTrailing = CGFloat(-20)
        
        static let noteTextViewTop = CGFloat(30)
        static let noteTextViewLeading = CGFloat(20)
        static let noteTextViewTrailing = CGFloat(-20)
        static let noteTextViewBottom = CGFloat(-20)
        
        static let transparentFooterViewHeight = CGFloat(100)
        
        static let saveButtonHeight = RoundedCornerButton.height
        static let saveButtonLeading = CGFloat(20)
        static let saveButtonTrailing = CGFloat(-20)
        static let saveButtonBottom = CGFloat(-40)
        static let saveButtonBottomForKeyboard = CGFloat(-20)
    }
    
    weak var listener: EnterBookmarkPresentableListener?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        registerToReceiveNotification()
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerToReceiveNotification()
        configureViews()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        urlTextField.becomeFirstResponder()
    }
    
    func update(with selectedTags: [Tag]) {
        self.selectedTags = selectedTags
        tagCollectionView.reloadData()
        if selectedTags.isEmpty { tagCollectionView.resetHeight() }
    }
    
    func dismiss() {
        dismiss(animated: true)
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
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
        headerView.addTargetToCloseButton(self, action: #selector(closeButtonDidTap))
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tagCollectionViewDidTap(_:)))
        tagCollectionView.addGestureRecognizer(tapGestureRecognizer)
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        scrollView.delegate = self
        urlTextField.listener = self
        noteTextView.listener = self
        
        view.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        view.addSubview(headerView)
        view.addSubview(scrollView)
        view.addSubview(saveButton)
        
        scrollView.addSubview(urlTextField)
        scrollView.addSubview(tagCollectionView)
        scrollView.addSubview(noteTextView)
        scrollView.addSubview(transparentFooterView)
        
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            scrollView.contentLayoutGuide.topAnchor.constraint(equalTo: scrollView.frameLayoutGuide.topAnchor),
            scrollView.contentLayoutGuide.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor),
            scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor),
            
            urlTextField.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: Metric.urlTextFieldTop),
            urlTextField.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: Metric.urlTextFieldLeading),
            urlTextField.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: Metric.urlTextFieldTrailing),
            
            tagCollectionView.topAnchor.constraint(equalTo: urlTextField.bottomAnchor, constant: Metric.tagCollectionViewTop),
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
            
            saveButton.heightAnchor.constraint(equalToConstant: Metric.saveButtonHeight),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.saveButtonLeading),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.saveButtonTrailing),
            saveButtonBottomConstraint
        ])
    }
    
    private func scrollToTop() {
        let offset = CGPoint(x: 0, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    private func scrollToBottom() {
        let offset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.frame.height)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    @objc
    private func closeButtonDidTap() {
        listener?.closeButtonDidTap()
    }
    
    @objc
    private func tagCollectionViewDidTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == .ended { listener?.tagCollectionViewDidTap(existingSelectedTags: selectedTags) }
    }
    
    @objc
    private func saveButtonDidTap() {
        guard let text = urlTextField.text, let url = URL(string: text) else {
            guard let alertController = AlertController(title: LocalizedString.AlertTitle.enterTheURL) else { return }
            view.endEditing(true)
            present(alertController, animated: true)
            return
        }
        let tags = selectedTags.count > 0 ? selectedTags : nil
        listener?.saveButtonDidTap(url: url, tags: tags, note: noteTextView.text)
    }
}

// MARK: - Scroll View

extension EnterBookmarkViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
}

// MARK: - Text Field

extension EnterBookmarkViewController: LabeledURLTextFieldListener {
    
    func textFieldDidBecomeFirstResponder() {
        scrollToTop()
    }
}

// MARK: - Collection View

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

// MARK: - Text View

extension EnterBookmarkViewController: LabeledNoteTextViewListener {
    
    func textViewDidBecomeFirstResponder() {
        scrollToBottom()
    }
    
    func textViewHeightDidIncrease() {
        scrollToBottom()
    }
}
