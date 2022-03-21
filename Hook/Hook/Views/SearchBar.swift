//
//  SearchBar.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/10.
//

import UIKit

final class SearchBar: UIControl {
    
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
        return textField
    }()

    @AutoLayout private var cancelButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = Font.cancelButton
        button.setTitle(LocalizedString.ActionTitle.cancel, for: .normal)
        button.setTitleColor(Asset.Color.secondaryColor, for: .normal)
        return button
    }()
    
    private var constantForContainerViewTrailing = CGFloat(0)
    private lazy var anchorForContainerViewTrailing = trailingAnchor
    
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
    
    init(placeholder: String,
         showsCancelButton: Bool = false,
         isInputEnabled: Bool = true,
         theme: ViewTheme = .normal) {
        super.init(frame: .zero)
        if theme == .sheet { containerView.backgroundColor = Asset.Color.sheetSearchBackgroundColor }
        configure(placeholder: placeholder,
                  showsCancelButton: showsCancelButton,
                  isInputEnabled: isInputEnabled)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(placeholder: "",
                  showsCancelButton: false,
                  isInputEnabled: false)
    }
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        return searchTextField.becomeFirstResponder()
    }
    
    func addTargetToCancelButton(_ target: AnyObject, action: Selector) {
        cancelButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    private func configure(placeholder: String,
                           showsCancelButton: Bool,
                           isInputEnabled: Bool) {
        let placeholderAttributes: [NSAttributedString.Key: Any] = [.font: Font.searchTextField, .foregroundColor: Asset.Color.sheetSearchTintColor]
        searchTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        searchTextField.isUserInteractionEnabled = isInputEnabled
        
        addSubview(containerView)
        containerView.addSubview(magnifyingglassImageView)
        containerView.addSubview(searchTextField)
        
        if showsCancelButton {
            constantForContainerViewTrailing = CGFloat(-15)
            anchorForContainerViewTrailing = cancelButton.leadingAnchor
            addSubview(cancelButton)
            NSLayoutConstraint.activate([
                cancelButton.widthAnchor.constraint(equalToConstant: cancelButtonWidth()),
                cancelButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: Metric.height),

            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: anchorForContainerViewTrailing, constant: constantForContainerViewTrailing),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            magnifyingglassImageView.widthAnchor.constraint(equalToConstant: Metric.magnifyingglassImageViewWidthHeight),
            magnifyingglassImageView.heightAnchor.constraint(equalToConstant: Metric.magnifyingglassImageViewWidthHeight),
            magnifyingglassImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            magnifyingglassImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Metric.magnifyingglassImageViewLeading),

            searchTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            searchTextField.leadingAnchor.constraint(equalTo: magnifyingglassImageView.trailingAnchor, constant: Metric.searchTextFieldLeading),
            searchTextField.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Metric.searchTextFieldTrailing)
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
