//
//  EditTagsInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/15.
//

import RIBs

protocol EditTagsRouting: ViewableRouting {}

protocol EditTagsPresentable: Presentable {
    var listener: EditTagsPresentableListener? { get set }
    func update(with tags: [Tag])
}

protocol EditTagsListener: AnyObject {
    func editTagsBackButtonDidTap()
    func editTagsSaveButtonDidTap(tags: [Tag])
    func editTagsDidRemove()
}

protocol EditTagsInteractorDependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
}

final class EditTagsInteractor: PresentableInteractor<EditTagsPresentable>, EditTagsInteractable, EditTagsPresentableListener {
    
    private let dependency: EditTagsInteractorDependency
    
    private var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
    
    weak var router: EditTagsRouting?
    weak var listener: EditTagsListener?
    
    init(presenter: EditTagsPresentable, dependency: EditTagsInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeTagsStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func backButtonDidTap() {
        listener?.editTagsBackButtonDidTap()
    }
    
    func saveButtonDidTap(tags: [Tag]) {
        listener?.editTagsSaveButtonDidTap(tags: tags)
    }
    
    func didRemove() {
        listener?.editTagsDidRemove()
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
}
