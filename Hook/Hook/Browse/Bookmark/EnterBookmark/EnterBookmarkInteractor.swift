//
//  EnterBookmarkInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs

protocol EnterBookmarkRouting: ViewableRouting {}

protocol EnterBookmarkPresentable: Presentable {
    var listener: EnterBookmarkPresentableListener? { get set }
    func update(with selectedTags: [Tag])
}

protocol EnterBookmarkListener: AnyObject {
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag])
    func enterBookmarkSaveButtonDidTap(url: URL, tags: [Tag]?, note: String?)
}

protocol EnterBookmarkInteractorDependency {
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class EnterBookmarkInteractor: PresentableInteractor<EnterBookmarkPresentable>, EnterBookmarkInteractable, EnterBookmarkPresentableListener {
    
    private let dependency: EnterBookmarkInteractorDependency
    
    private var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
    weak var router: EnterBookmarkRouting?
    weak var listener: EnterBookmarkListener?
    
    init(presenter: EnterBookmarkPresentable, dependency: EnterBookmarkInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeSelectedTagsStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func tagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        listener?.enterBookmarkTagCollectionViewDidTap(existingSelectedTags: existingSelectedTags)
    }
    
    func saveButtonDidTap(url: URL, tags: [Tag]?, note: String?) {
        listener?.enterBookmarkSaveButtonDidTap(url: url, tags: tags, note: note)
        selectedTagsStream.update(with: [])
    }
    
    private func subscribeSelectedTagsStream() {
        selectedTagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
}
