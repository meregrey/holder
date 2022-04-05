//
//  SettingsViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/31.
//

import RIBs
import UIKit

protocol SettingsPresentableListener: AnyObject {
    func appearanceOptionViewDidTap()
    func sortBookmarksOptionViewDidTap()
}

final class SettingsViewController: UIViewController, SettingsPresentable, SettingsViewControllable {
    
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
    
    @AutoLayout private var appearanceOptionView = SettingsOptionView(title: LocalizedString.ViewTitle.appearance)
    @AutoLayout private var sortBookmarksOptionView = SettingsOptionView(title: LocalizedString.ViewTitle.sortBookmarks)
    @AutoLayout private var clearDataOptionView = SettingsOptionView(title: LocalizedString.ViewTitle.clearData)
    
    private enum Font {
        static let titleLabel = UIFont.systemFont(ofSize: 30, weight: .bold)
    }
    
    private enum Image {
        static let tabBarItem = UIImage(named: "settings")
    }
    
    private enum Metric {
        static let titleLabelTop = CGFloat(100)
        static let titleLabelLeading = CGFloat(20)
        static let titleLabelTrailing = CGFloat(-20)
        
        static let stackViewTop = CGFloat(20)
        static let stackViewLeading = CGFloat(20)
        static let stackViewTrailing = CGFloat(-20)
    }
    
    weak var listener: SettingsPresentableListener?
    
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
        navigationController?.isNavigationBarHidden = true
    }
    
    func push(_ viewControllable: ViewControllable) {
        navigationController?.pushViewController(viewControllable.uiviewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    private func configureViews() {
        appearanceOptionView.addTarget(self, action: #selector(appearanceOptionViewDidTap), for: .touchUpInside)
        sortBookmarksOptionView.addTarget(self, action: #selector(sortBookmarksOptionViewDidTap), for: .touchUpInside)
        clearDataOptionView.addTarget(self, action: #selector(clearDataOptionViewDidTap), for: .touchUpInside)
        
        tabBarItem = UITabBarItem(title: nil,
                                  image: Image.tabBarItem,
                                  selectedImage: Image.tabBarItem)
        
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        view.addSubview(titleLabel)
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(appearanceOptionView)
        stackView.addArrangedSubview(sortBookmarksOptionView)
        stackView.addArrangedSubview(clearDataOptionView)
        
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
    private func appearanceOptionViewDidTap() {
        listener?.appearanceOptionViewDidTap()
    }
    
    @objc
    private func sortBookmarksOptionViewDidTap() {
        listener?.sortBookmarksOptionViewDidTap()
    }
    
    @objc
    private func clearDataOptionViewDidTap() {}
}
