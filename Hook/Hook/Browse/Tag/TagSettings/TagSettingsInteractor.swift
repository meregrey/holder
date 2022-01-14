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
}

protocol TagSettingsListener: AnyObject {
    func tagSettingsBackButtonDidTap()
    func tagSettingsAddTagButtonDidTap()
    func tagSettingsEditTagTableViewRowDidSelect(tag: Tag)
}

protocol TagSettingsInteractorDependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
}

final class TagSettingsInteractor: PresentableInteractor<TagSettingsPresentable>, TagSettingsInteractable, TagSettingsPresentableListener {
    
    private let dependency: TagSettingsInteractorDependency
    
    private var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
    
    weak var router: TagSettingsRouting?
    weak var listener: TagSettingsListener?
    
    init(presenter: TagSettingsPresentable, dependency: TagSettingsInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeTagsStream()
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
    
    func editTagTableViewRowDidSelect(tag: Tag) {
        listener?.tagSettingsEditTagTableViewRowDidSelect(tag: tag)
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
}
