//
//  EnterTagInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/12.
//

import RIBs

protocol EnterTagRouting: ViewableRouting {}

protocol EnterTagPresentable: Presentable {
    var listener: EnterTagPresentableListener? { get set }
}

protocol EnterTagListener: AnyObject {
    func enterTagBackButtonDidTap()
    func enterTagSaveButtonDidTap()
    func enterTagDidRemove()
}

protocol EnterTagInteractorDependency {
    var mode: EnterTagMode { get }
}

final class EnterTagInteractor: PresentableInteractor<EnterTagPresentable>, EnterTagInteractable, EnterTagPresentableListener {
    
    private let tagRepository = TagRepository.shared
    private let dependency: EnterTagInteractorDependency
    
    private var mode: EnterTagMode { dependency.mode }
    
    weak var router: EnterTagRouting?
    weak var listener: EnterTagListener?
    
    init(presenter: EnterTagPresentable, dependency: EnterTagInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func backButtonDidTap() {
        listener?.enterTagBackButtonDidTap()
    }
    
    func saveButtonDidTap(tag: Tag) {
        guard canContinueSaving(tag) else {
            listener?.enterTagSaveButtonDidTap()
            return
        }
        switch mode {
        case .add: addTag(tag)
        case .edit(let existingTag): updateTag(existingTag, to: tag)
        }
        listener?.enterTagSaveButtonDidTap()
    }
    
    func didRemove() {
        listener?.enterTagDidRemove()
    }
    
    private func canContinueSaving(_ tag: Tag) -> Bool {
        let result = tagRepository.isExisting(tag.name)
        switch result {
        case .success(let isExisting):
            if isExisting { NotificationCenter.post(named: NotificationName.Tag.existingTag) }
            return !isExisting
        case .failure(_):
            NotificationCenter.post(named: NotificationName.Store.didFailToCheck)
            return false
        }
    }
    
    private func addTag(_ tag: Tag) {
        let result = tagRepository.add(tag)
        switch result {
        case .success(_): NotificationCenter.post(named: NotificationName.Tag.didSucceedToAddTag)
        case .failure(_): NotificationCenter.post(named: NotificationName.Tag.didFailToAddTag)
        }
    }
    
    private func updateTag(_ tag: Tag, to newTag: Tag) {
        let result = tagRepository.update(tag, to: newTag)
        switch result {
        case .success(_): break
        case .failure(_): NotificationCenter.post(named: NotificationName.Tag.didFailToUpdateTag)
        }
    }
}
