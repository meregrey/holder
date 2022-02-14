//
//  TagInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs
import RxSwift

protocol TagRouting: Routing {
    func cleanupViews()
    func attachTagBar()
    func attachTagSettings()
    func detachTagSettings(includingView isIncludedView: Bool)
    func attachEnterTag(mode: EnterTagMode)
    func detachEnterTag(includingView isIncludedView: Bool)
    func attachEditTags()
    func detachEditTags(includingView isIncludedView: Bool)
    func attachSelectTags(existingSelectedTags: [Tag])
    func detachSelectTags()
    func attachSearchTags()
    func detachSearchTags()
}

protocol TagListener: AnyObject {}

protocol TagInteractorDependency {
    var tagRepository: TagRepositoryType { get }
}

final class TagInteractor: Interactor, TagInteractable {
    
    private let dependency: TagInteractorDependency
    
    private var tagRepository: TagRepositoryType { dependency.tagRepository }
    
    weak var router: TagRouting?
    weak var listener: TagListener?
    
    init(dependency: TagInteractorDependency) {
        self.dependency = dependency
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        router?.attachTagBar()
    }
    
    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
    
    // MARK: - TagBar
    
    func tagBarTagSettingsButtonDidTap() {
        router?.attachTagSettings()
    }
    
    // MARK: - TagSettings
    
    func tagSettingsBackButtonDidTap() {
        router?.detachTagSettings(includingView: true)
    }
    
    func tagSettingsAddTagButtonDidTap() {
        router?.attachEnterTag(mode: .add)
    }
    
    func tagSettingsEditTagsButtonDidTap() {
        router?.attachEditTags()
    }
    
    func tagSettingsEditTagTableViewRowDidSelect(tag: Tag) {
        router?.attachEnterTag(mode: .edit(tag: tag))
    }
    
    func tagSettingsDidRemove() {
        router?.detachTagSettings(includingView: false)
    }
    
    // MARK: - EnterTag
    
    func enterTagBackButtonDidTap() {
        router?.detachEnterTag(includingView: true)
    }
    
    func enterTagSaveButtonDidTap(mode: EnterTagMode, tag: Tag) {
        switch mode {
        case .add: tagRepository.add(tag: tag)
        case .edit(let existingTag): tagRepository.update(tag: existingTag, to: tag)
        }
        router?.detachEnterTag(includingView: true)
    }
    
    func enterTagDidRemove() {
        router?.detachEnterTag(includingView: false)
    }
    
    // MARK: - EditTags
    
    func editTagsBackButtonDidTap() {
        router?.detachEditTags(includingView: true)
    }
    
    func editTagsSaveButtonDidTap(tags: [Tag]) {
        tagRepository.update(tags: tags)
        router?.detachEditTags(includingView: true)
    }
    
    func editTagsDidRemove() {
        router?.detachEditTags(includingView: false)
    }
    
    // MARK: - SelectTags
    
    func selectTagsCloseButtonDidTap() {
        router?.detachSelectTags()
    }
    
    func selectTagsSearchBarDidTap() {
        router?.attachSearchTags()
    }
    
    func selectTagsDoneButtonDidTap() {
        router?.detachSelectTags()
    }
    
    // MARK: - SearchTags
    
    func searchTagsCancelButtonDidTap() {
        router?.detachSearchTags()
    }
    
    func searchTagsRowDidSelect(tag: Tag, shouldAddTag: Bool) {
        if shouldAddTag { tagRepository.add(tag: tag) }
        router?.detachSearchTags()
    }
}
