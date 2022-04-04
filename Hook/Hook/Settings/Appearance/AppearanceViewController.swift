//
//  AppearanceViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/04/04.
//

import RIBs
import UIKit

protocol AppearancePresentableListener: AnyObject {
    func backButtonDidTap()
    func didRemove()
}

final class AppearanceViewController: UIViewController, AppearancePresentable, AppearanceViewControllable {
    
    @AutoLayout private var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        return stackView
    }()
    
    @AutoLayout private var systemSettingChoiceView = ChoiceView(title: LocalizedString.ActionTitle.systemSetting)
    @AutoLayout private var lightChoiceView = ChoiceView(title: LocalizedString.ActionTitle.light)
    @AutoLayout private var darkChoiceView = ChoiceView(title: LocalizedString.ActionTitle.dark)
    
    private enum Image {
        static let back = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
    }
    
    private enum Metric {
        static let stackViewTop = CGFloat(20)
        static let stackViewLeading = CGFloat(20)
        static let stackViewTrailing = CGFloat(-20)
    }
    
    weak var listener: AppearancePresentableListener?
    
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
        select()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    private func configureViews() {
        title = LocalizedString.ViewTitle.appearance
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.back, style: .done, target: self, action: #selector(backButtonDidTap))
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        systemSettingChoiceView.addTarget(self, action: #selector(systemSettingChoiceViewDidTap))
        lightChoiceView.addTarget(self, action: #selector(lightChoiceViewDidTap))
        darkChoiceView.addTarget(self, action: #selector(darkChoiceViewDidTap))
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(systemSettingChoiceView)
        stackView.addArrangedSubview(lightChoiceView)
        stackView.addArrangedSubview(darkChoiceView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.stackViewTrailing)
        ])
    }
    
    private func select() {
        let interfaceStyle = UserDefaults.value(forType: InterfaceStyle.self) ?? .systemSetting
        systemSettingChoiceView.select(interfaceStyle == .systemSetting)
        lightChoiceView.select(interfaceStyle == .light)
        darkChoiceView.select(interfaceStyle == .dark)
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.backButtonDidTap()
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
        view.window?.adoptInterfaceStyle(interfaceStyle)
        UserDefaults.set(interfaceStyle)
        select()
    }
}
