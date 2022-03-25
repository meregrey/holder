//
//  SearchBar.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/10.
//

import UIKit

final class SearchBar: UIControl {
    
    static var height: CGFloat { Metric.height }
    
    @AutoLayout private var containerView: RoundedCornerView = {
        let view = RoundedCornerView()
        view.backgroundColor = Asset.Color.searchBackgroundColor
        return view
    }()

    @AutoLayout private var magnifyingglassImageView: UIImageView = {
        let imageView = UIImageView(image: Image.magnifyingglassImageView)
        imageView.tintColor = Asset.Color.sheetSearchTintColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    @AutoLayout private var searchTextField: UITextField = {
        let textField = UITextField()
        textField.font = Font.searchTextField
        textField.textColor = Asset.Color.sheetSearchTintColor
        textField.clearButtonMode = .whileEditing
        textField.autocapitalizationType = .none
        textField.returnKeyType = .search
        textField.enablesReturnKeyAutomatically = true
        return textField
    }()

    @AutoLayout private var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Font.cancelButton
        button.setTitle(LocalizedString.ActionTitle.cancel, for: .normal)
        button.setTitleColor(Asset.Color.secondaryColor, for: .normal)
        button.isHidden = true
        return button
    }()
    
    private var isInputEnabled: Bool
    private var showsCancelButton: Bool
    
    private lazy var containerViewTrailingConstraint = NSLayoutConstraint(item: containerView,
                                                                          attribute: .trailing,
                                                                          relatedBy: .equal,
                                                                          toItem: self,
                                                                          attribute: .trailing,
                                                                          multiplier: 1,
                                                                          constant: 0)
    
    private lazy var cancelButtonTrailingConstraint = NSLayoutConstraint(item: cancelButton,
                                                                         attribute: .trailing,
                                                                         relatedBy: .equal,
                                                                         toItem: self,
                                                                         attribute: .trailing,
                                                                         multiplier: 1,
                                                                         constant: cancelButtonWidth())
    
    private enum Image {
        static let magnifyingglassImageView = UIImage(systemName: "magnifyingglass", withConfiguration: UIImage.SymbolConfiguration(weight: .medium))
    }
    
    private enum Font {
        static let searchTextField = UIFont.systemFont(ofSize: 17, weight: .semibold)
        static let cancelButton = UIFont.systemFont(ofSize: 17, weight: .semibold)
    }
    
    private enum Metric {
        static let height = CGFloat(50)
        
        static let magnifyingglassImageViewWidthHeight = CGFloat(25)
        static let magnifyingglassImageViewLeading = CGFloat(15)
        
        static let searchTextFieldLeading = CGFloat(10)
        static let searchTextFieldTrailing = CGFloat(-10)
    }
    
    var text: String? { searchTextField.text }
    
    weak var listener: UITextFieldDelegate? {
        didSet { searchTextField.delegate = listener }
    }
    
    init(placeholder: String,
         isInputEnabled: Bool = true,
         showsCancelButton: Bool = false,
         theme: ViewTheme = .normal) {
        self.isInputEnabled = isInputEnabled
        self.showsCancelButton = showsCancelButton
        super.init(frame: .zero)
        if theme == .sheet { containerView.backgroundColor = Asset.Color.sheetSearchBackgroundColor }
        registerToReceiveNotification()
        configure(placeholder: placeholder)
    }

    required init?(coder: NSCoder) {
        self.isInputEnabled = false
        self.showsCancelButton = false
        super.init(coder: coder)
        registerToReceiveNotification()
        configure(placeholder: "")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return searchTextField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()
        return searchTextField.resignFirstResponder()
    }
    
    func addTargetToCancelButton(_ target: AnyObject, action: Selector) {
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func endSearch() {
        searchTextField.text = ""
        searchTextField.resignFirstResponder()
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.showCancelButton(false)
            self.layoutIfNeeded()
        }
    }
    
    func showCancelButton(_ flag: Bool) {
        let containerViewConstant = flag ? -(cancelButtonWidth() + 15) : 0
        let cancelButtonConstant = flag ? 0 : cancelButtonWidth()
        containerViewTrailingConstraint.constant = containerViewConstant
        cancelButtonTrailingConstraint.constant = cancelButtonConstant
        cancelButton.isHidden = !flag
    }
    
    func setSearchTerm(_ searchTerm: String) {
        searchTextField.text = searchTerm
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(textFieldDidBeginEditing),
                                       name: UITextField.textDidBeginEditingNotification)
    }
    
    @objc
    private func textFieldDidBeginEditing() {
        guard isInputEnabled == true, showsCancelButton == false else { return }
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.showCancelButton(true)
            self.layoutIfNeeded()
        }
    }
    
    private func configure(placeholder: String) {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.font: Font.searchTextField, .foregroundColor: Asset.Color.sheetSearchTintColor]
        searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        searchTextField.isUserInteractionEnabled = isInputEnabled
        
        addSubview(containerView)
        addSubview(cancelButton)
        containerView.addSubview(magnifyingglassImageView)
        containerView.addSubview(searchTextField)
        
        if showsCancelButton { showCancelButton(true) }
        
        containerViewTrailingConstraint.isActive = true
        cancelButtonTrailingConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),

            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            magnifyingglassImageView.widthAnchor.constraint(equalToConstant: Metric.magnifyingglassImageViewWidthHeight),
            magnifyingglassImageView.heightAnchor.constraint(equalToConstant: Metric.magnifyingglassImageViewWidthHeight),
            magnifyingglassImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            magnifyingglassImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.magnifyingglassImageViewLeading),

            searchTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: magnifyingglassImageView.trailingAnchor, constant: Metric.searchTextFieldLeading),
            searchTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.searchTextFieldTrailing),
            
            cancelButton.widthAnchor.constraint(equalToConstant: cancelButtonWidth()),
            cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func cancelButtonWidth() -> CGFloat {
        let button = UIButton()
        button.titleLabel?.font = Font.cancelButton
        button.setTitle(LocalizedString.ActionTitle.cancel, for: .normal)
        let targetSize = CGSize(width: UIView.layoutFittingCompressedSize.width, height: 0)
        return button.systemLayoutSizeFitting(targetSize).width
    }
}
