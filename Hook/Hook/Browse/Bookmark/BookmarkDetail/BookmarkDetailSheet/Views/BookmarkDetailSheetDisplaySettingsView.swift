//
//  BookmarkDetailSheetDisplaySettingsView.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/16.
//

import UIKit

final class BookmarkDetailSheetDisplaySettingsView: RoundedCornerView {
    
    static let height = CGFloat(205)
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 12
        return stackView
    }()
    
    @AutoLayout private var systemSettingView = BookmarkDetailSheetDisplaySettingsOptionView(title: LocalizedString.ActionTitle.systemSetting)
    @AutoLayout private var lightView = BookmarkDetailSheetDisplaySettingsOptionView(title: LocalizedString.ActionTitle.light)
    @AutoLayout private var darkView = BookmarkDetailSheetDisplaySettingsOptionView(title: LocalizedString.ActionTitle.dark)
    
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
        checkInterfaceStyle()
        
        systemSettingView.addTarget(self, action: #selector(systemSettingViewDidTap))
        lightView.addTarget(self, action: #selector(lightViewDidTap))
        darkView.addTarget(self, action: #selector(darkViewDidTap))
        
        backgroundColor = Asset.Color.sheetBaseBackgroundColor
        
        addSubview(stackView)
        stackView.addArrangedSubview(systemSettingView)
        stackView.addArrangedSubview(lightView)
        stackView.addArrangedSubview(darkView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: Metric.stackViewTrailing),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: Metric.stackViewBottom)
        ])
    }
    
    private func checkInterfaceStyle() {
        let interfaceStyle = UserDefaults.value(forType: InterfaceStyle.self) ?? .systemSetting
        systemSettingView.check(interfaceStyle == .systemSetting)
        lightView.check(interfaceStyle == .light)
        darkView.check(interfaceStyle == .dark)
    }
    
    private func handleInterfaceStyle(_ interfaceStyle: InterfaceStyle) {
        window?.adoptInterfaceStyle(interfaceStyle)
        UserDefaults.set(interfaceStyle)
        checkInterfaceStyle()
    }
    
    @objc
    private func systemSettingViewDidTap() {
        handleInterfaceStyle(.systemSetting)
    }
    
    @objc
    private func lightViewDidTap() {
        handleInterfaceStyle(.light)
    }
    
    @objc
    private func darkViewDidTap() {
        handleInterfaceStyle(.dark)
    }
}

private final class BookmarkDetailSheetDisplaySettingsOptionView: UIView {
    
    @AutoLayout private var titleButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(Asset.Color.primaryColor, for: .normal)
        return button
    }()
    
    @AutoLayout private var checkmarkImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        imageView.tintColor = Asset.Color.primaryColor
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        return imageView
    }()
    
    private enum Metric {
        static let checkmarkImageViewWidthHeight = CGFloat(22)
    }
    
    init(title: String) {
        super.init(frame: .zero)
        configure(with: title)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(with: "")
    }
    
    func addTarget(_ target: Any?, action: Selector) {
        titleButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func check(_ flag: Bool) {
        checkmarkImageView.isHidden = !flag
    }
    
    private func configure(with title: String) {
        titleButton.setTitle(title, for: .normal)
        
        addSubview(titleButton)
        addSubview(checkmarkImageView)
        
        NSLayoutConstraint.activate([
            titleButton.topAnchor.constraint(equalTo: topAnchor),
            titleButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            checkmarkImageView.widthAnchor.constraint(equalToConstant: Metric.checkmarkImageViewWidthHeight),
            checkmarkImageView.heightAnchor.constraint(equalToConstant: Metric.checkmarkImageViewWidthHeight),
            checkmarkImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkImageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
