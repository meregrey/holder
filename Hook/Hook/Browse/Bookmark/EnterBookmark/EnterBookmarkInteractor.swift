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
    func update(with tags: [Tag])
}

protocol EnterBookmarkListener: AnyObject {
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag])
}

protocol EnterBookmarkInteractorDependency {
    var selectedTagsStream: ReadOnlyStream<[Tag]> { get }
}

final class EnterBookmarkInteractor: PresentableInteractor<EnterBookmarkPresentable>, EnterBookmarkInteractable, EnterBookmarkPresentableListener {
    
    private let dependency: EnterBookmarkInteractorDependency
    
    private var selectedTagsStream: ReadOnlyStream<[Tag]> { dependency.selectedTagsStream }
    
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
    
    private func subscribeSelectedTagsStream() {
        selectedTagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
}
