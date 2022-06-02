//
//  ShareInteractor.swift
//  ShareExtension
//
//  Created by Yeojin Yoon on 2022/04/19.
//

import LinkPresentation
import RIBs

protocol ShareRouting: Routing {
    func cleanupViews()
    func attachSelectTags(existingSelectedTags: [Tag])
    func detachSelectTags()
    func attachSearchTags()
    func detachSearchTags()
}

protocol ShareListener: AnyObject {}

protocol ShareInteractorDependency {
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class ShareInteractor: Interactor, ShareInteractable, ShareViewControllerListener {
    
    weak var router: ShareRouting?
    weak var listener: ShareListener?
    weak var viewController: ShareViewControllable?
    
    private let dependency: ShareInteractorDependency
    
    private var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
    init(dependency: ShareInteractorDependency) {
        self.dependency = dependency
        super.init()
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeSelectedTagsStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
        router?.cleanupViews()
    }
    
    func tagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        router?.attachSelectTags(existingSelectedTags: existingSelectedTags)
    }
    
    func saveButtonDidTap(bookmark: Bookmark) {
        LPMetadataProvider().startFetchingMetadata(for: bookmark.url) { metadata, _ in
            let bookmark = bookmark.updated(title: metadata?.title)
            let result = BookmarkRepository.shared.add(bookmark: bookmark)
            switch result {
            case .success(_): self.updateLastShareDate()
            case .failure(_): break
            }
            self.viewController?.completeRequest()
        }
    }
    
    private func subscribeSelectedTagsStream() {
        selectedTagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.viewController?.update(with: $0)
        }
    }
    
    private func updateLastShareDate() {
        guard let userDefaults = UserDefaults(suiteName: UserDefaults.suiteName) else { return }
        userDefaults.set(Date(), forKey: UserDefaults.suiteKey)
    }
    
    // MARK: - SelectTags
    
    func selectTagsCancelButtonDidTap() {
        router?.detachSelectTags()
    }
    
    func selectTagsSearchBarDidTap(forNavigation isForNavigation: Bool) {
        router?.attachSearchTags()
    }
    
    func selectTagsDoneButtonDidTap(forNavigation isForNavigation: Bool) {
        router?.detachSelectTags()
    }
    
    func selectTagsBackButtonDidTap() {}
    
    func selectTagsDidRemove() {}
    
    // MARK: - SearchTags
    
    func searchTagsCancelButtonDidTap(forNavigation isForNavigation: Bool) {
        router?.detachSearchTags()
    }
    
    func searchTagsRowDidSelect(forNavigation isForNavigation: Bool) {
        router?.detachSearchTags()
    }
    
    func searchTagsBackButtonDidTap() {}
    
    func searchTagsDidRemove() {}
}
