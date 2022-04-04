//
//  BookmarkDetailSheetAppearanceSettingsView.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/16.
//

import UIKit

final class BookmarkDetailSheetAppearanceSettingsView: RoundedCornerView {
    
    static let height = CGFloat(215)
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    @AutoLayout private var systemSettingSelectionView = SelectionView(title: LocalizedString.ActionTitle.systemSetting)
    @AutoLayout private var lightSelectionView = SelectionView(title: LocalizedString.ActionTitle.light)
    @AutoLayout private var darkSelectionView = SelectionView(title: LocalizedString.ActionTitle.dark)
    
    private enum Metric {
        static let stackViewTop = CGFloat(24)
        static let stackViewLeading = CGFloat(24)
        static let stackViewTrailing = CGFloat(-24)
        static let stackViewBottom = CGFloat(-68)
    }
    
    init() {
        super.init(cornerRadius: 20)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    private func configure() {
        select()
        
        systemSettingSelectionView.addTarget(self, action: #selector(systemSettingSelectionViewDidTap))
        lightSelectionView.addTarget(self, action: #selector(lightSelectionViewDidTap))
        darkSelectionView.addTarget(self, action: #selector(darkSelectionViewDidTap))
        
        backgroundColor = Asset.Color.sheetBaseBackgroundColor
        
        addSubview(stackView)
        stackView.addArrangedSubview(systemSettingSelectionView)
        stackView.addArrangedSubview(lightSelectionView)
        stackView.addArrangedSubview(darkSelectionView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.stackViewTrailing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Metric.stackViewBottom)
        ])
    }
    
    private func select() {
        let interfaceStyle = UserDefaults.value(forType: InterfaceStyle.self) ?? .systemSetting
        systemSettingSelectionView.select(interfaceStyle == .systemSetting)
        lightSelectionView.select(interfaceStyle == .light)
        darkSelectionView.select(interfaceStyle == .dark)
    }
    
    @objc
    private func systemSettingSelectionViewDidTap() {
        handleInterfaceStyle(.systemSetting)
    }
    
    @objc
    private func lightSelectionViewDidTap() {
        handleInterfaceStyle(.light)
    }
    
    @objc
    private func darkSelectionViewDidTap() {
        handleInterfaceStyle(.dark)
    }
    
    private func handleInterfaceStyle(_ interfaceStyle: InterfaceStyle) {
        window?.adoptInterfaceStyle(interfaceStyle)
        UserDefaults.set(interfaceStyle)
        select()
    }
}
