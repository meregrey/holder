//
//  EnterBookmarkInteractor.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import CoreData
import LinkPresentation
import RIBs

protocol EnterBookmarkRouting: ViewableRouting {}

protocol EnterBookmarkPresentable: Presentable {
    var listener: EnterBookmarkPresentableListener? { get set }
    func update(with selectedTags: [Tag])
    func dismiss()
}

protocol EnterBookmarkListener: AnyObject {
    func enterBookmarkCloseButtonDidTap()
    func enterBookmarkTagCollectionViewDidTap(existingSelectedTags: [Tag])
    func enterBookmarkSaveButtonDidTap()
}

protocol EnterBookmarkInteractorDependency {
    var context: NSManagedObjectContext { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class EnterBookmarkInteractor: PresentableInteractor<EnterBookmarkPresentable>, EnterBookmarkInteractable, EnterBookmarkPresentableListener {
    
    private let dependency: EnterBookmarkInteractorDependency
    
    private var context: NSManagedObjectContext { dependency.context }
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
    
    func closeButtonDidTap() {
        listener?.enterBookmarkCloseButtonDidTap()
        clearSelectedTagsStream()
    }
    
    func tagCollectionViewDidTap(existingSelectedTags: [Tag]) {
        listener?.enterBookmarkTagCollectionViewDidTap(existingSelectedTags: existingSelectedTags)
    }
    
    func saveButtonDidTap(url: URL, tags: [Tag]?, note: String?) {
        presenter.dismiss()
        clearSelectedTagsStream()
        if isExisting(url) {
            listener?.enterBookmarkSaveButtonDidTap()
            return
        }
        attemptToSave(url: url, tags: tags, note: note)
    }
    
    private func subscribeSelectedTagsStream() {
        selectedTagsStream.subscribe(disposedOnDeactivate: self) { [weak self] in
            self?.presenter.update(with: $0)
        }
    }
    
    private func isExisting(_ url: URL) -> Bool {
        let request = BookmarkEntity.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(BookmarkEntity.urlString), url.absoluteString)
        request.predicate = predicate
        do {
            let count = try context.count(for: request)
            if count > 0 { NotificationCenter.default.post(name: NotificationName.Bookmark.existingBookmark, object: nil) }
            return count > 0
        } catch {
            NotificationCenter.default.post(name: NotificationName.Store.didFailToCheck, object: nil)
            return true
        }
    }
    
    private func attemptToSave(url: URL, tags: [Tag]?, note: String?) {
        LPMetadataProvider().startFetchingMetadata(for: url) { metadata, error in
            guard error == nil else {
                NotificationCenter.default.post(name: NotificationName.Metadata.didFailToFetch, object: nil)
                return
            }
            let bookmarkEntity = BookmarkEntity(context: self.context)
            bookmarkEntity.configure(url: url, tags: tags, note: note, title: metadata?.title, host: url.host)
            do {
                try self.context.save()
            } catch {
                NotificationCenter.default.post(name: NotificationName.Store.didFailToSave, object: nil)
            }
            self.listener?.enterBookmarkSaveButtonDidTap()
        }
    }
    
    private func clearSelectedTagsStream() {
        selectedTagsStream.update(with: [])
    }
}
