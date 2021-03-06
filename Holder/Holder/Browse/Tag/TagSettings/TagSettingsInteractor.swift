//
//  TagSettingsInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import CoreData
import RIBs

protocol TagSettingsRouting: ViewableRouting {}

protocol TagSettingsPresentable: Presentable {
    var listener: TagSettingsPresentableListener? { get set }
    func update(with fetchedResultsController: NSFetchedResultsController<TagEntity>)
    func scrollToBottom()
}

protocol TagSettingsListener: AnyObject {
    func tagSettingsBackButtonDidTap()
    func tagSettingsAddTagButtonDidTap()
    func tagSettingsEditTagsButtonDidTap()
    func tagSettingsTagDidSelect(tag: Tag)
    func tagSettingsDidRemove()
}

final class TagSettingsInteractor: PresentableInteractor<TagSettingsPresentable>, TagSettingsInteractable, TagSettingsPresentableListener {
    
    weak var router: TagSettingsRouting?
    weak var listener: TagSettingsListener?
    
    override init(presenter: TagSettingsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        registerToReceiveNotification()
        performFetch()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func backButtonDidTap() {
        listener?.tagSettingsBackButtonDidTap()
    }
    
    func addTagButtonDidTap() {
        listener?.tagSettingsAddTagButtonDidTap()
    }
    
    func editTagsButtonDidTap() {
        listener?.tagSettingsEditTagsButtonDidTap()
    }
    
    func tagDidSelect(tag: Tag) {
        listener?.tagSettingsTagDidSelect(tag: tag)
    }
    
    func didRemove() {
        listener?.tagSettingsDidRemove()
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(didSucceedToAddTag),
                                       name: NotificationName.Tag.didSucceedToAddTag)
        
        NotificationCenter.addObserver(self,
                                       selector: #selector(lastShareDateDidChange),
                                       name: NotificationName.lastShareDateDidChange)
    }
    
    @objc
    private func didSucceedToAddTag() {
        presenter.scrollToBottom()
    }
    
    @objc
    private func lastShareDateDidChange() {
        performFetch()
    }
    
    private func performFetch() {
        let fetchedResultsController = TagRepository.shared.fetchedResultsController()
        try? fetchedResultsController.performFetch()
        presenter.update(with: fetchedResultsController)
    }
}
