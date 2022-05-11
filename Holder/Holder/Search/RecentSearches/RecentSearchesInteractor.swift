//
//  RecentSearchesInteractor.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/22.
//

import RIBs

protocol RecentSearchesRouting: ViewableRouting {}

protocol RecentSearchesPresentable: Presentable {
    var listener: RecentSearchesPresentableListener? { get set }
    func update(with searchTerms: [String])
}

protocol RecentSearchesListener: AnyObject {
    func recentSearchesSearchTermDidSelect(searchTerm: String)
}

protocol RecentSearchesInteractorDependency {
    var searchTermStream: ReadOnlyStream<String> { get }
}

final class RecentSearchesInteractor: PresentableInteractor<RecentSearchesPresentable>, RecentSearchesInteractable, RecentSearchesPresentableListener {
    
    weak var router: RecentSearchesRouting?
    weak var listener: RecentSearchesListener?
    
    private let userDefaults = UserDefaults.standard
    private let userDefaultsKey = "RecentSearches"
    private let dependency: RecentSearchesInteractorDependency
    
    private var searchTerms: [String] = [] {
        didSet { presenter.update(with: searchTerms) }
    }
    
    private var searchTermStream: ReadOnlyStream<String> { dependency.searchTermStream }
    
    init(presenter: RecentSearchesPresentable, dependency: RecentSearchesInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        searchTerms = fetchSearchTerms()
        registerToReceiveNotification()
        subscribeSearchTermStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
        NotificationCenter.default.removeObserver(self)
    }
    
    func searchTermDidSelect(searchTerm: String) {
        listener?.recentSearchesSearchTermDidSelect(searchTerm: searchTerm)
    }
    
    func clearButtonDidTap() {
        userDefaults.set(nil, forKey: userDefaultsKey)
        searchTerms = []
    }
    
    private func fetchSearchTerms() -> [String] {
        return userDefaults.stringArray(forKey: userDefaultsKey) ?? []
    }
    
    private func registerToReceiveNotification() {
        NotificationCenter.addObserver(self,
                                       selector: #selector(noSearchResultsDidFind(_:)),
                                       name: NotificationName.Bookmark.noSearchResults)
    }
    
    @objc
    private func noSearchResultsDidFind(_ notification: Notification) {
        guard let searchTerm = notification.userInfo?[Notification.UserInfoKey.searchTerm] as? String else { return }
        guard let index = searchTerms.firstIndex(of: searchTerm) else { return }
        searchTerms.remove(at: index)
        userDefaults.set(searchTerms, forKey: userDefaultsKey)
    }
    
    private func subscribeSearchTermStream() {
        searchTermStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            guard $0.count > 0 else { return }
            self?.updateSearchTerms(with: $0)
            self?.presenter.update(with: self?.searchTerms ?? [])
        }
    }
    
    private func updateSearchTerms(with searchTerm: String) {
        var searchTerms = fetchSearchTerms()
        if let index = searchTerms.firstIndex(of: searchTerm) { searchTerms.remove(at: index) }
        searchTerms.insert(searchTerm, at: 0)
        userDefaults.set(searchTerms, forKey: userDefaultsKey)
        self.searchTerms = searchTerms
    }
}
