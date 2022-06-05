//
//  ClearDataViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/04/06.
//

import RIBs
import UIKit

protocol ClearDataPresentableListener: AnyObject {
    func backButtonDidTap()
    func clearButtonDidTap()
    func didRemove()
}

final class ClearDataViewController: UIViewController, ClearDataPresentable, ClearDataViewControllable {
    
    weak var listener: ClearDataPresentableListener?
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var explanationLabel: UILabel = {
        let label = UILabel()
        label.font = Font.explanationLabel
        label.textColor = Asset.Color.primaryColor
        label.numberOfLines = 0
        return label
    }()
    
    @AutoLayout private var clearButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ActionTitle.clear, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.backgroundColor = Asset.Color.primaryColor
        return button
    }()
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 26, weight: .bold)
        static let explanationLabel = UIFont.systemFont(ofSize: 17)
    }
    
    private enum Image {
        static let backButton = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let titleLabelTop = CGFloat(60)
        static let titleLabelLeading = CGFloat(20)
        static let titleLabelTrailing = CGFloat(-20)
        
        static let explanationLabelTop = CGFloat(20)
        static let explanationLabelLeading = CGFloat(20)
        static let explanationLabelTrailing = CGFloat(-20)
        
        static let clearButtonLeading = CGFloat(20)
        static let clearButtonTrailing = CGFloat(-20)
        static let clearButtonBottom = CGFloat(-40)
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    private func configureViews() {
        titleLabel.text = LocalizedString.LabelText.clearData
        explanationLabel.attributedText = explanationLabelAttributedText(explanation: LocalizedString.LabelText.clearDataExplanation)
        clearButton.addTarget(self, action: #selector(clearButtonDidTap), for: .touchUpInside)
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.backButton, style: .done, target: self, action: #selector(backButtonDidTap))
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.detailBackgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(explanationLabel)
        view.addSubview(clearButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.titleLabelTop),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.titleLabelTrailing),
            
            explanationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metric.explanationLabelTop),
            explanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.explanationLabelLeading),
            explanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.explanationLabelTrailing),
            
            clearButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.clearButtonLeading),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.clearButtonTrailing),
            clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.clearButtonBottom)
        ])
    }
    
    private func explanationLabelAttributedText(explanation: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        return NSAttributedString(string: explanation, attributes: [.paragraphStyle: paragraphStyle])
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.backButtonDidTap()
    }
    
    @objc
    private func clearButtonDidTap() {
        listener?.clearButtonDidTap()
    }
}
