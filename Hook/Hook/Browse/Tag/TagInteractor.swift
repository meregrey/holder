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
    func detachTop()
    func attachTagBar()
    func attachTagSettings()
    func detachTagSettings()
    func attachEnterTag(mode: EnterTagMode)
    func detachEnterTag()
}

protocol TagListener: AnyObject {
    func setCurrentTopContent(_ content: BrowseContent?)
}

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
    
    func reportCurrentTopContent(_ content: BrowseContent?) {
        listener?.setCurrentTopContent(content)
    }
    
    // MARK: - TagBar
    
    func tagBarTagSettingsButtonDidTap() {
        router?.attachTagSettings()
    }
    
    // MARK: - TagSettings
    
    func tagSettingsBackButtonDidTap() {
        router?.detachTagSettings()
    }
    
    func tagSettingsAddTagButtonDidTap() {
        router?.attachEnterTag(mode: .add)
    }
    
    func tagSettingsEditTagTableViewRowDidSelect(tag: Tag) {
        router?.attachEnterTag(mode: .edit(tag: tag))
    }
    
    // MARK: - EnterTag
    
    func enterTagBackButtonDidTap() {
        router?.detachEnterTag()
    }
    
    func enterTagSaveButtonDidTap(mode: EnterTagMode, tag: Tag) {
        switch mode {
        case .add: tagRepository.add(tag: tag)
        case .edit(let existingTag): tagRepository.update(tag: existingTag, to: tag)
        }
        router?.detachEnterTag()
    }
}
