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
            _ = BookmarkRepository.shared.add(bookmark: bookmark)
            self.viewController?.completeRequest()
        }
    }
    
    private func subscribeSelectedTagsStream() {
        selectedTagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.viewController?.update(with: $0)
        }
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
