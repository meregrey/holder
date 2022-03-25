//
//  TagBarInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs

protocol TagBarRouting: ViewableRouting {}

protocol TagBarPresentable: Presentable {
    var listener: TagBarPresentableListener? { get set }
    func update(with tags: [Tag])
    func update(with currentTag: Tag)
}

protocol TagBarListener: AnyObject {
    func tagBarTagSettingsButtonDidTap()
}

protocol TagBarInteractorDependency {
    var currentTagStream: MutableStream<Tag> { get }
}

final class TagBarInteractor: PresentableInteractor<TagBarPresentable>, TagBarInteractable, TagBarPresentableListener {
    
    private let tagsStream = TagRepository.shared.tagsStream
    private let dependency: TagBarInteractorDependency
    
    private var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
    
    weak var router: TagBarRouting?
    weak var listener: TagBarListener?
    
    init(presenter: TagBarPresentable, dependency: TagBarInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeTagsStream()
        subscribeCurrentTagStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func viewDidAppearFirst() {
        guard let tag = tagsStream.value.first else { return }
        currentTagStream.update(with: tag)
    }
    
    func tagDidSelect(tag: Tag) {
        currentTagStream.update(with: tag)
    }
    
    func tagSettingsButtonDidTap() {
        listener?.tagBarTagSettingsButtonDidTap()
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
    
    private func subscribeCurrentTagStream() {
        currentTagStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
}
