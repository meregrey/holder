//
//  BookmarkDetailSheetViewController.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/16.
//

import RIBs
import UIKit

protocol BookmarkDetailSheetPresentableListener: AnyObject {
    func didRequestToDetach()
    func reloadActionDidTap()
    func editActionDidTap()
    func deleteActionDidTap()
}

final class BookmarkDetailSheetViewController: SheetController, BookmarkDetailSheetPresentable, BookmarkDetailSheetViewControllable {
    
    @AutoLayout private var displaySettingsView = BookmarkDetailSheetDisplaySettingsView()
    
    private var displaySettingsViewHeight: CGFloat { BookmarkDetailSheetDisplaySettingsView.height }
    
    private lazy var displaySettingsViewBottomConstraint = NSLayoutConstraint(item: displaySettingsView,
                                                                              attribute: .bottom,
                                                                              relatedBy: .equal,
                                                                              toItem: view,
                                                                              attribute: .bottom,
                                                                              multiplier: 1,
                                                                              constant: displaySettingsViewHeight)
    
    private lazy var displaySettingsAction = Action(title: LocalizedString.ActionTitle.displaySettings) { [weak self] in
        self?.displaySettingsActionDidTap()
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
    
    weak var listener: BookmarkDetailSheetPresentableListener?
    
    override init() {
        super.init()
        actions = [displaySettingsAction, reloadAction, editAction, deleteAction]
        handlerToDisappear = { [weak self] in
            self?.performToDisappear()
        }
        configureDisplaySettingsView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func performToDisappear() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
            self.prepareToDisappear()
            self.displaySettingsViewBottomConstraint.constant = self.displaySettingsViewHeight
            self.view.layoutIfNeeded()
        } completion: { _ in
            self.listener?.didRequestToDetach()
        }
    }
    
    private func configureDisplaySettingsView() {
        view.addSubview(displaySettingsView)
        displaySettingsViewBottomConstraint.isActive = true
        NSLayoutConstraint.activate([
            displaySettingsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            displaySettingsView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc
    private func displaySettingsActionDidTap() {
        hideContainerView { [weak self] in
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, options: .curveLinear) {
                self?.displaySettingsViewBottomConstraint.constant = 20
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
