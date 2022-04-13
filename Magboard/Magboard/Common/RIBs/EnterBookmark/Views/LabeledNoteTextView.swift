//
//  LabeledNoteTextView.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/02/15.
//

import UIKit

protocol LabeledNoteTextViewListener: AnyObject {
    func textViewDidBecomeFirstResponder()
    func textViewHeightDidIncrease()
}

final class LabeledNoteTextView: LabeledView {
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView()
        view.backgroundColor = Asset.Color.sheetUpperBackgroundColor
        view.layer.cornerRadius = Metric.containerViewCornerRadius
        view.layer.cornerCurve = .continuous
        return view
    }()
    
    @AutoLayout private var textView: UITextView = {
        let textView = UITextView()
        textView.font = Font.textView
        textView.textColor = Asset.Color.sheetTextColor
        textView.textContainerInset = Metric.textViewInset
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    @AutoLayout private var clearButton: UIButton = {
        let button = UIButton()
        button.setImage(Image.clearButton, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.tintColor = Asset.Color.secondaryColor
        button.isHidden = true
        button.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        return button
    }()
    
    private lazy var existingHeight = bounds.height
    private lazy var textViewTrailingConstraint = NSLayoutConstraint(item: textView,
                                                                     attribute: .trailing,
                                                                     relatedBy: .equal,
                                                                     toItem: containerView,
                                                                     attribute: .trailing,
                                                                     multiplier: 1,
                                                                     constant: -12)
    
    private enum Font {
        static let textView = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    private enum Image {
        static let clearButton = UIImage(systemName: "xmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
    }
    
    private enum Metric {
        static let containerViewCornerRadius = CGFloat(12)
        
        static let textViewInset = UIEdgeInsets(top: 17, left: 12, bottom: 17, right: 0)
        
        static let clearButtonWidthHeight = CGFloat(21)
        static let clearButtonTrailing = CGFloat(-12)
    }
    
    override var bounds: CGRect {
        didSet {
            if bounds.height > existingHeight { listener?.textViewHeightDidIncrease() }
            existingHeight = bounds.height
        }
    }
    
    var text: String { textView.text }
    
    weak var listener: LabeledNoteTextViewListener?
    
    init(header: String) {
        super.init(header: header, theme: .sheet)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    func setText(_ text: String?) {
        textView.text = text
    }
    
    private func configure() {
        textView.delegate = self
        
        addSubviewUnderLabel(containerView)
        containerView.addSubview(textView)
        containerView.addSubview(clearButton)
        
        textViewTrailingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: containerView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            clearButton.widthAnchor.constraint(equalToConstant: Metric.clearButtonWidthHeight),
            clearButton.heightAnchor.constraint(equalToConstant: Metric.clearButtonWidthHeight),
            clearButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            clearButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.clearButtonTrailing)
        ])
    }
    
    @objc
    private func clearButtonDidTap() {
        textView.text = ""
    }
}

extension LabeledNoteTextView: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewTrailingConstraint.constant = -45
        clearButton.isHidden = false
        listener?.textViewDidBecomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        clearButton.isHidden = true
        textViewTrailingConstraint.constant = -12
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
}
