//
//  AppearanceViewController.swift
//  Holder
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
        stackView.spacing = 12
        return stackView
    }()
    
    @AutoLayout private var systemSettingSelectionView = SelectionView(title: LocalizedString.ActionTitle.systemSetting)
    
    @AutoLayout private var lightSelectionView = SelectionView(title: LocalizedString.ActionTitle.light)
    
    @AutoLayout private var darkSelectionView = SelectionView(title: LocalizedString.ActionTitle.dark)
    
    private enum Image {
        static let backButton = UIImage(systemName: "chevron.left", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
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
        selectInterfaceStyle()
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil { listener?.didRemove() }
    }
    
    private func configureViews() {
        title = LocalizedString.ViewTitle.appearance
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Image.backButton, style: .done, target: self, action: #selector(backButtonDidTap))
        hidesBottomBarWhenPushed = true
        view.backgroundColor = Asset.Color.baseBackgroundColor
        
        systemSettingSelectionView.addTarget(self, action: #selector(systemSettingSelectionViewDidTap), for: .touchUpInside)
        lightSelectionView.addTarget(self, action: #selector(lightSelectionViewDidTap), for: .touchUpInside)
        darkSelectionView.addTarget(self, action: #selector(darkSelectionViewDidTap), for: .touchUpInside)
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(systemSettingSelectionView)
        stackView.addArrangedSubview(lightSelectionView)
        stackView.addArrangedSubview(darkSelectionView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Metric.stackViewTop),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Metric.stackViewLeading),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Metric.stackViewTrailing)
        ])
    }
    
    private func selectInterfaceStyle() {
        let interfaceStyle = UserDefaults.value(forType: InterfaceStyle.self) ?? .systemSetting
        systemSettingSelectionView.select(interfaceStyle == .systemSetting)
        lightSelectionView.select(interfaceStyle == .light)
        darkSelectionView.select(interfaceStyle == .dark)
    }
    
    @objc
    private func backButtonDidTap() {
        listener?.backButtonDidTap()
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
        view.window?.adoptInterfaceStyle(interfaceStyle)
        UserDefaults.set(interfaceStyle)
        selectInterfaceStyle()
    }
}
