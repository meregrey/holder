//
//  TagSettingsInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/10.
//

import RIBs

protocol TagSettingsRouting: ViewableRouting {}

protocol TagSettingsPresentable: Presentable {
    var listener: TagSettingsPresentableListener? { get set }
    func update(with tags: [Tag])
    func scrollToBottom()
}

protocol TagSettingsListener: AnyObject {
    func tagSettingsBackButtonDidTap()
    func tagSettingsAddTagButtonDidTap()
    func tagSettingsEditTagsButtonDidTap()
    func tagSettingsEditTagTableViewRowDidSelect(tag: Tag)
    func tagSettingsDidRemove()
}

final class TagSettingsInteractor: PresentableInteractor<TagSettingsPresentable>, TagSettingsInteractable, TagSettingsPresentableListener {
    
    private let tagsStream = TagRepository.shared.tagsStream
    
    weak var router: TagSettingsRouting?
    weak var listener: TagSettingsListener?
    
    override init(presenter: TagSettingsPresentable) {
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeTagsStream()
        registerToReceiveNotification()
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
    
    func editTagTableViewRowDidSelect(tag: Tag) {
        listener?.tagSettingsEditTagTableViewRowDidSelect(tag: tag)
    }
    
    func didRemove() {
        listener?.tagSettingsDidRemove()
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(didSucceedToAddTag),
                                       name: NotificationName.Tag.didSucceedToAddTag)
    }
    
    @objc
    private func didSucceedToAddTag() {
        presenter.scrollToBottom()
    }
}
