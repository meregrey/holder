//
//  VersionViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/06/08.
//

import RIBs
import UIKit

protocol VersionPresentableListener: AnyObject {
    func backButtonDidTap()
    func openAppStoreButtonDidTap()
    func didRemove()
}

final class VersionViewController: UIViewController, VersionPresentable, VersionViewControllable {
    
    weak var listener: VersionPresentableListener?
    
    private let isLatestVersion: Bool
    private let currentVersion: String
    
    @AutoLayout private var explanationLabel: UILabel = {
        let label = UILabel()
        label.font = Font.explanationLabel
        label.textColor = Asset.Color.primaryColor
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    @AutoLayout private var currentVersionLabel: UILabel = {
        let label = UILabel()
        label.font = Font.currentVersionLabel
        label.textColor = Asset.Color.primaryColor
        label.textAlignment = .center
        return label
    }()
    
    @AutoLayout private var openAppStoreButton: RoundedCornerButton = {
        let button = RoundedCornerButton()
        button.setTitle(LocalizedString.ActionTitle.openAppStore, for: .normal)
        button.setTitleColor(Asset.Color.tertiaryColor, for: .normal)
        button.backgroundColor = Asset.Color.primaryColor
        return button
    }()
    
    private enum Font {
        static let explanationLabel = UIFont.systemFont(ofSize: 24, weight: .bold)
        static let currentVersionLabel = UIFont.systemFont(ofSize: 17)
        static let openAppStoreButton = UIFont.systemFont(ofSize: 17, weight: .medium)
    }
    
    private enum Image {
        static let backButton = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let explanationLabelTop = UIScreen.main.bounds.height / 2 - 50
        static let explanationLabelLeading = CGFloat(20)
        static let explanationLabelTrailing = CGFloat(-20)
        
        static let currentVersionLabelTop = CGFloat(12)
        static let currentVersionLabelLeading = CGFloat(20)
        static let currentVersionLabelTrailing = CGFloat(-20)
        
        static let openAppStoreButtonLeading = CGFloat(20)
        static let openAppStoreButtonTrailing = CGFloat(-20)
        static let openAppStoreButtonBottom = CGFloat(-40)
    }
    
    init(isLatestVersion: Bool, currentVersion: String) {
        self.isLatestVersion = isLatestVersion
        self.currentVersion = currentVersion
        super.init(nibName: nil, bundle: nil)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        self.isLatestVersion = false
        self.currentVersion = ""
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
        explanationLabel.text = isLatestVersion ? LocalizedString.LabelText.versionExplanationForLatestVersion : LocalizedString.LabelText.versionExplanationForUpdateAvailable
        currentVersionLabel.text = "\(LocalizedString.LabelText.versionExplanationForCurrentVersion): \(currentVersion)"
        openAppStoreButton.addTarget(self, action: #selector(openAppStoreButtonDidTap), for: .touchUpInside)
        
        title = LocalizedString.ViewTitle.version
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.backButton, style: .done, target: self, action: #selector(backButtonDidTap))
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.detailBackgroundColor
        
        view.addSubview(explanationLabel)
        view.addSubview(currentVersionLabel)
        view.addSubview(openAppStoreButton)
        
        NSLayoutConstraint.activate([
            explanationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Metric.explanationLabelTop),
            explanationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.explanationLabelLeading),
            explanationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.explanationLabelTrailing),
            
            currentVersionLabel.topAnchor.constraint(equalTo: explanationLabel.bottomAnchor, constant: Metric.currentVersionLabelTop),
            currentVersionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.currentVersionLabelLeading),
            currentVersionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.currentVersionLabelTrailing),
            
            openAppStoreButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.openAppStoreButtonLeading),
            openAppStoreButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.openAppStoreButtonTrailing),
            openAppStoreButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metric.openAppStoreButtonBottom)
        ])
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.backButtonDidTap()
    }
    
    @objc
    private func openAppStoreButtonDidTap() {
        listener?.openAppStoreButtonDidTap()
    }
}
