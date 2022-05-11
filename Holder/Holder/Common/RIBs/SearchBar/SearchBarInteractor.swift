//
//  SearchBarInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import RIBs

protocol SearchBarRouting: ViewableRouting {}

protocol SearchBarPresentable: Presentable {
    var listener: SearchBarPresentableListener? { get set }
    func update(with searchTerm: String)
}

protocol SearchBarListener: AnyObject {
    func searchBarDidSearch()
    func searchBarCancelButtonDidTap()
}

protocol SearchBarInteractorDependency {
    var searchTermStream: MutableStream<String> { get }
}

final class SearchBarInteractor: PresentableInteractor<SearchBarPresentable>, SearchBarInteractable, SearchBarPresentableListener {
    
    weak var router: SearchBarRouting?
    weak var listener: SearchBarListener?
    
    private let dependency: SearchBarInteractorDependency
    
    private var searchTermStream: MutableStream<String> { dependency.searchTermStream }
    
    init(presenter: SearchBarPresentable, dependency: SearchBarInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeSearchTermStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func didSearch(searchTerm: String) {
        searchTermStream.update(with: searchTerm)
        listener?.searchBarDidSearch()
    }
    
    func cancelButtonDidTap() {
        searchTermStream.update(with: "")
        listener?.searchBarCancelButtonDidTap()
    }
    
    private func subscribeSearchTermStream() {
        searchTermStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            guard $0.count > 0 else { return }
            self?.presenter.update(with: $0)
        }
    }
}
