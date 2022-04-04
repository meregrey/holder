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
    
    @AutoLayout private var systemSettingChoiceView = ChoiceView(title: LocalizedString.ActionTitle.systemSetting)
    @AutoLayout private var lightChoiceView = ChoiceView(title: LocalizedString.ActionTitle.light)
    @AutoLayout private var darkChoiceView = ChoiceView(title: LocalizedString.ActionTitle.dark)
    
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
        
        systemSettingChoiceView.addTarget(self, action: #selector(systemSettingChoiceViewDidTap))
        lightChoiceView.addTarget(self, action: #selector(lightChoiceViewDidTap))
        darkChoiceView.addTarget(self, action: #selector(darkChoiceViewDidTap))
        
        backgroundColor = Asset.Color.sheetBaseBackgroundColor
        
        addSubview(stackView)
        stackView.addArrangedSubview(systemSettingChoiceView)
        stackView.addArrangedSubview(lightChoiceView)
        stackView.addArrangedSubview(darkChoiceView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.stackViewTrailing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Metric.stackViewBottom)
        ])
    }
    
    private func select() {
        let interfaceStyle = UserDefaults.value(forType: InterfaceStyle.self) ?? .systemSetting
        systemSettingChoiceView.select(interfaceStyle == .systemSetting)
        lightChoiceView.select(interfaceStyle == .light)
        darkChoiceView.select(interfaceStyle == .dark)
    }
    
    @objc
    private func systemSettingChoiceViewDidTap() {
        handleInterfaceStyle(.systemSetting)
    }
    
    @objc
    private func lightChoiceViewDidTap() {
        handleInterfaceStyle(.light)
    }
    
    @objc
    private func darkChoiceViewDidTap() {
        handleInterfaceStyle(.dark)
    }
    
    private func handleInterfaceStyle(_ interfaceStyle: InterfaceStyle) {
        window?.adoptInterfaceStyle(interfaceStyle)
        UserDefaults.set(interfaceStyle)
        select()
    }
}
