//
//  BookmarkBrowserInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import CoreData
import RIBs

protocol BookmarkBrowserRouting: ViewableRouting {}

protocol BookmarkBrowserPresentable: Presentable {
    var listener: BookmarkBrowserPresentableListener? { get set }
    func update(with tags: [Tag])
    func update(with currentTag: Tag)
}

protocol BookmarkBrowserListener: AnyObject {
    func bookmarkBrowserAddBookmarkButtonDidTap()
}

protocol BookmarkBrowserInteractorDependency {
    var context: NSManagedObjectContext { get }
    var tagsStream: ReadOnlyStream<[Tag]> { get }
    var currentTagStream: MutableStream<Tag> { get }
}

final class BookmarkBrowserInteractor: PresentableInteractor<BookmarkBrowserPresentable>, BookmarkBrowserInteractable, BookmarkBrowserPresentableListener {
    
    private let dependency: BookmarkBrowserInteractorDependency
    
    private var context: NSManagedObjectContext { dependency.context }
    private var tagsStream: ReadOnlyStream<[Tag]> { dependency.tagsStream }
    private var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
    
    weak var router: BookmarkBrowserRouting?
    weak var listener: BookmarkBrowserListener?
    
    init(presenter: BookmarkBrowserPresentable, dependency: BookmarkBrowserInteractorDependency) {
        self.dependency = dependency
        super.init(presenter: presenter)
        presenter.listener = self
    }
    
    override func didBecomeActive() {
        super.didBecomeActive()
        subscribeTagsStream()
        subscribeCurrentTagStream()
    }
    
    override func willResignActive() {
        super.willResignActive()
    }
    
    func indexPathDidChange(indexPath: IndexPath) {
        let currentTag = tagsStream.value[indexPath.item]
        currentTagStream.update(with: currentTag)
    }
    
    func addBookmarkButtonDidTap() {
        listener?.bookmarkBrowserAddBookmarkButtonDidTap()
    }
    
    private func subscribeTagsStream() {
        tagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
    
    private func subscribeCurrentTagStream() {
        currentTagStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            guard $0.name.count > 0 else { return }
            self?.presenter.update(with: $0)
        }
    }
}
