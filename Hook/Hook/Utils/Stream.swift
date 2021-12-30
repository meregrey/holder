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
    func update(withValue value: T)
}

class ReadOnlyStream<T: Equatable>: ReadOnlyStreamType {

    fileprivate let relay: BehaviorRelay<T>

    fileprivate var stream: Observable<T> {
        return relay
            .asObservable()
            .distinctUntilChanged()
    }

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
    
    func update(withValue value: T) {
        relay.accept(value)
    }
}
