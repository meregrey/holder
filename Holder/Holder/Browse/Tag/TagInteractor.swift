//
//  TagInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs
import RxSwift

protocol TagRouting: Routing {
    func cleanupViews()
    func attachTagBar()
    func attachTagSettings()
    func detachTagSettings(includingView isViewIncluded: Bool)
    func attachEnterTag(mode: EnterTagMode)
    func detachEnterTag(includingView isViewIncluded: Bool)
    func attachEditTags()
    func detachEditTags(includingView isViewIncluded: Bool)
    func attachSelectTags(existingSelectedTags: [Tag])
    func detachSelectTags()
    func attachSearchTags()
    func detachSearchTags()
}

protocol TagListener: AnyObject {}

final class TagInteractor: Interactor, TagInteractable {
    
    weak var router: TagRouting?
    weak var listener: TagListener?
    
    override init() {
        super.init()
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
    
    func tagSettingsTagDidSelect(tag: Tag) {
        router?.attachEnterTag(mode: .edit(tag: tag))
    }
    
    func tagSettingsDidRemove() {
        router?.detachTagSettings(includingView: false)
    }
    
    // MARK: - EnterTag
    
    func enterTagBackButtonDidTap() {
        router?.detachEnterTag(includingView: true)
    }
    
    func enterTagSaveButtonDidTap() {
        router?.detachEnterTag(includingView: true)
    }
    
    func enterTagDidRemove() {
        router?.detachEnterTag(includingView: false)
    }
    
    // MARK: - EditTags
    
    func editTagsBackButtonDidTap() {
        router?.detachEditTags(includingView: true)
    }
    
    func editTagsSaveButtonDidTap() {
        router?.detachEditTags(includingView: true)
    }
    
    func editTagsDidRemove() {
        router?.detachEditTags(includingView: false)
    }
    
    // MARK: - SelectTags
    
    func selectTagsCancelButtonDidTap() {
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
    
    func searchTagsRowDidSelect() {
        router?.detachSearchTags()
    }
}
