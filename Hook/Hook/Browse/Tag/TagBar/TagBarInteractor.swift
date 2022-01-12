//
//  TagBarInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs
import RxSwift

protocol TagBarRouting: ViewableRouting {}

protocol TagBarPresentable: Presentable {
    var listener: TagBarPresentableListener? { get set }
    func update(with tags: [Tag])
}

protocol TagBarListener: AnyObject {
    func tagBarTagSettingsButtonDidTap()
}

protocol TagBarInteractorDependency {
    var tagsStream: ReadOnlyStream<[Tag]> { get }
}

final class TagBarInteractor: PresentableInteractor<TagBarPresentable>, TagBarInteractable, TagBarPresentableListener {
    
    private let dependency: TagBarInteractorDependency
    
    private var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
    
    weak var router: TagBarRouting?
    weak var listener: TagBarListener?
    
    init(presenter: TagBarPresentable, dependency: TagBarInteractorDependency) {
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
    
    func tagSettingsButtonDidTap() {
        listener?.tagBarTagSettingsButtonDidTap()
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
}
