//
//  SettingsViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs
import UIKit

protocol SettingsPresentableListener: AnyObject {
    func appearanceOptionViewDidTap()
    func sortBookmarksOptionViewDidTap()
    func clearDataOptionViewDidTap()
}

final class SettingsViewController: UIViewController, SettingsPresentable, SettingsViewControllable {
    
    weak var listener: SettingsPresentableListener?
    
    private static let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    
    @AutoLayout private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = LocalizedString.ViewTitle.settings
        label.font = Font.titleLabel
        label.textColor = Asset.Color.primaryColor
        return label
    }()
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    @AutoLayout private var enableSharingOptionView = SettingsOptionView(title: LocalizedString.ViewTitle.enableSharing)
    
    @AutoLayout private var appearanceOptionView = SettingsOptionView(title: LocalizedString.ViewTitle.appearance)
    
    @AutoLayout private var sortBookmarksOptionView = SettingsOptionView(title: LocalizedString.ViewTitle.sortBookmarks)
    
    @AutoLayout private var clearDataOptionView = SettingsOptionView(title: LocalizedString.ViewTitle.clearData)
    
    @AutoLayout private var versionOptionView = SettingsOptionView(title: LocalizedString.LabelText.version, info: version)
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 30, weight: .bold)
    }
    
    private enum Image {
        static let tabBarItem = UIImage(systemName: "gearshape.fill")?.imageForTabBarItem()
    }
    
    private enum Metric {
        static let titleLabelTop = CGFloat(100)
        static let titleLabelLeading = CGFloat(20)
        static let titleLabelTrailing = CGFloat(-20)
        
        static let stackViewTop = CGFloat(20)
        static let stackViewLeading = CGFloat(20)
        static let stackViewTrailing = CGFloat(-20)
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
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithTransparentBackground()
        navigationBarAppearance.backgroundColor = Asset.Color.detailBackgroundColor
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = Asset.Color.primaryColor
        navigationController?.isNavigationBarHidden = true
    }
    
    func push(_ viewController: ViewControllable) {
        navigationController?.pushViewController(viewController.uiviewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureViews() {
        enableSharingOptionView.addTarget(self, action: #selector(enableSharingOptionViewDidTap), for: .touchUpInside)
        appearanceOptionView.addTarget(self, action: #selector(appearanceOptionViewDidTap), for: .touchUpInside)
        sortBookmarksOptionView.addTarget(self, action: #selector(sortBookmarksOptionViewDidTap), for: .touchUpInside)
        clearDataOptionView.addTarget(self, action: #selector(clearDataOptionViewDidTap), for: .touchUpInside)
        
        tabBarItem = UITabBarItem(title: nil,
                                  image: Image.tabBarItem,
                                  selectedImage: Image.tabBarItem)
        
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        stackView.addArrangedSubview(enableSharingOptionView)
        stackView.addArrangedSubview(appearanceOptionView)
        stackView.addArrangedSubview(sortBookmarksOptionView)
        stackView.addArrangedSubview(clearDataOptionView)
        stackView.addArrangedSubview(versionOptionView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: Metric.titleLabelTop),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.titleLabelLeading),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.titleLabelTrailing),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.stackViewTrailing)
        ])
    }
    
    @objc
    private func enableSharingOptionViewDidTap() {
        navigationController?.pushViewController(EnableSharingViewController(), animated: true)
    }
    
    @objc
    private func appearanceOptionViewDidTap() {
        listener?.appearanceOptionViewDidTap()
    }
    
    @objc
    private func sortBookmarksOptionViewDidTap() {
        listener?.sortBookmarksOptionViewDidTap()
    }
    
    @objc
    private func clearDataOptionViewDidTap() {
        listener?.clearDataOptionViewDidTap()
    }
}
