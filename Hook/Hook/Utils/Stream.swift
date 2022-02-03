//
//  Stream.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import RIBs
import RxRelay
import RxSwift

fileprivate protocol ReadOnlyStreamType: AnyObject {
    associatedtype T
    var stream: Observable<T> { get }
    func subscribe(disposedOnDeactivate interactor: Interactor, action: @escaping (T) -> Void)
}

fileprivate protocol MutableStreamType: ReadOnlyStreamType {
    func update(with value: T)
}

class ReadOnlyStream<T: Equatable>: ReadOnlyStreamType {

    fileprivate let relay: BehaviorRelay<T>

    fileprivate var stream: Observable<T> {
        return relay
            .asObservable()
            .distinctUntilChanged()
    }
    
    var value: T { relay.value }

    init(initialValue: T) {
        self.relay = BehaviorRelay(value: initialValue)
    }
    
    func subscribe(disposedOnDeactivate interactor: Interactor, action: @escaping (T) -> Void) {
        stream
            .subscribe(onNext: { action($0) })
            .disposeOnDeactivate(interactor: interactor)
    }
}

final class MutableStream<T: Equatable>: ReadOnlyStream<T>, MutableStreamType {
    
    func update(with value: T) {
        relay.accept(value)
    }
}

extension MutableStream where T == [Tag: [Bookmark]] {
    
    func update(with bookmark: Bookmark) {
        var dictionary = value
        var tags: [Tag]
        
        if let bookmarkTags = bookmark.tags {
            tags = [Tag(name: TagName.all)] + bookmarkTags.map({ Tag(name: $0.name) })
        } else {
            tags = [Tag(name: TagName.all)]
        }
        
        tags.forEach {
            if var bookmarks = dictionary[$0] {
                bookmarks.insert(bookmark, at: 0)
                dictionary.updateValue(bookmarks, forKey: $0)
            } else {
                dictionary.updateValue([bookmark], forKey: $0)
            }
        }
        
        update(with: dictionary)
    }
}
