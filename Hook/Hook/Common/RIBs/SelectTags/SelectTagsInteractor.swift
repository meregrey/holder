//
//  SelectTagsInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/04.
//

import RIBs

protocol SelectTagsRouting: ViewableRouting {}

protocol SelectTagsPresentable: Presentable {
    var listener: SelectTagsPresentableListener? { get set }
    func update(with tags: [Tag], existingSelectedTags: [Tag])
    func update(with tagBySearch: Tag)
}

protocol SelectTagsListener: AnyObject {
    func selectTagsCloseButtonDidTap()
    func selectTagsSearchBarDidTap()
    func selectTagsDoneButtonDidTap()
}

protocol SelectTagsInteractorDependency {
    var existingSelectedTags: [Tag] { get }
    var tagBySearchStream: MutableStream<Tag> { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class SelectTagsInteractor: PresentableInteractor<SelectTagsPresentable>, SelectTagsInteractable, SelectTagsPresentableListener {
    
    private let tagsStream = TagRepository.shared.tagsStream
    private let dependency: SelectTagsInteractorDependency
    
    private var existingSelectedTags: [Tag] { dependency.existingSelectedTags }
    private var tagBySearchStream: MutableStream<Tag> { dependency.tagBySearchStream }
    private var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
    weak var router: SelectTagsRouting?
    weak var listener: SelectTagsListener?
    
    init(presenter: SelectTagsPresentable, dependency: SelectTagsInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeTagsStream()
        subscribeTagBySearchStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
        resetSelectedTagStream()
    }
    
    func closeButtonDidTap() {
        listener?.selectTagsCloseButtonDidTap()
    }
    
    func searchBarDidTap() {
        listener?.selectTagsSearchBarDidTap()
    }
    
    func doneButtonDidTap(selectedTags: [Tag]) {
        selectedTagsStream.update(with: selectedTags)
        listener?.selectTagsDoneButtonDidTap()
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0, existingSelectedTags: self?.existingSelectedTags ?? [])
        }
    }
    
    private func subscribeTagBySearchStream() {
        tagBySearchStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            if $0.name.count > 0 { self?.presenter.update(with: $0) }
        }
    }
    
    private func resetSelectedTagStream() {
        tagBySearchStream.update(with: Tag(name: ""))
    }
}
