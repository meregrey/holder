//
//  BookmarkDetailSheetViewController.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/16.
//

import RIBs
import UIKit

protocol BookmarkDetailSheetPresentableListener: AnyObject {
    func reloadActionDidTap()
    func editActionDidTap()
    func deleteActionDidTap()
    func didRequestToDetach()
}

final class BookmarkDetailSheetViewController: SheetController, BookmarkDetailSheetPresentable, BookmarkDetailSheetViewControllable {
    
    weak var listener: BookmarkDetailSheetPresentableListener?
    
    @AutoLayout private var appearanceSettingsView = BookmarkDetailSheetAppearanceSettingsView()
    
    private var appearanceSettingsViewHeight: CGFloat { BookmarkDetailSheetAppearanceSettingsView.height }
    
    private lazy var appearanceSettingsViewBottomConstraint = NSLayoutConstraint(item: appearanceSettingsView,
                                                                                 attribute: .bottom,
                                                                                 relatedBy: .equal,
                                                                                 toItem: view,
                                                                                 attribute: .bottom,
                                                                                 multiplier: 1,
                                                                                 constant: appearanceSettingsViewHeight)
    
    private lazy var appearanceSettingsAction = Action(title: LocalizedString.ActionTitle.appearanceSettings) { [weak self] in
        self?.appearanceSettingsActionDidTap()
    }
    
    private lazy var reloadAction = Action(title: LocalizedString.ActionTitle.reload) { [weak self] in
        self?.reloadActionDidTap()
    }
    
    private lazy var editAction = Action(title: LocalizedString.ActionTitle.edit) { [weak self] in
        self?.editActionDidTap()
    }
    
    private lazy var deleteAction = Action(title: LocalizedString.ActionTitle.delete) { [weak self] in
        self?.deleteActionDidTap()
    }
    
    override init() {
        super.init()
        actions = [appearanceSettingsAction, reloadAction, editAction, deleteAction]
        handlerToDisappear = { [weak self] in
            self?.performToDisappear()
        }
        configureAppearanceSettingsView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func performToDisappear() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.prepareToDisappear()
            self.appearanceSettingsViewBottomConstraint.constant = self.appearanceSettingsViewHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.listener?.didRequestToDetach()
        }
    }
    
    private func configureAppearanceSettingsView() {
        view.addSubview(appearanceSettingsView)
        
        appearanceSettingsViewBottomConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            appearanceSettingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            appearanceSettingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc
    private func appearanceSettingsActionDidTap() {
        hideContainerView { [weak self] in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self?.appearanceSettingsViewBottomConstraint.constant = 20
                self?.view.layoutIfNeeded()
            }
        }
    }
    
    @objc
    private func reloadActionDidTap() {
        listener?.reloadActionDidTap()
    }
    
    @objc
    private func editActionDidTap() {
        listener?.editActionDidTap()
    }
    
    @objc
    private func deleteActionDidTap() {
        listener?.deleteActionDidTap()
    }
}
