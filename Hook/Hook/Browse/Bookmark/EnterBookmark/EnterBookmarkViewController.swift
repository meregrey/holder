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
    
    @AutoLayout private var scrollView = UIScrollView()
    
    @AutoLayout private var urlTextField = LabeledURLTextField(header: "URL")
    
    @AutoLayout private var tagCollectionView = LabeledTagCollectionView(header: LocalizedString.LabelTitle.tags)
    
    @AutoLayout private var noteTextView = LabeledNoteTextView(header: LocalizedString.LabelTitle.note)
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        urlTextField.becomeFirstResponder()
    }
    
    func update(with tags: [Tag]) {
        selectedTags = tags
        tagCollectionView.reloadData()
        if selectedTags.isEmpty { tagCollectionView.resetHeight() }
    }
    
    private func configureViews() {
        urlTextField.delegate = self
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tagCollectionViewDidTap(_:)))
        tagCollectionView.addGestureRecognizer(tapGestureRecognizer)
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        view.backgroundColor = Asset.Color.sheetBaseBackgroundColor
        view.addSubview(headerView)
        view.addSubview(scrollView)
        
        scrollView.addSubview(urlTextField)
        scrollView.addSubview(tagCollectionView)
        scrollView.addSubview(noteTextView)
        
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
            noteTextView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: Metric.noteTextViewBottom)
        ])
    }
    
    @objc
    private func tagCollectionViewDidTap(_ tapGestureRecognizer: UITapGestureRecognizer) {
        if tapGestureRecognizer.state == .ended { listener?.tagCollectionViewDidTap(existingSelectedTags: selectedTags) }
    }
}

// MARK: - UITextField

extension EnterBookmarkViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        urlTextField.resignFirstResponder()
        return true
    }
}

// MARK: - UICollectionView

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
