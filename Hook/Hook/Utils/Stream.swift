//
//  Stream.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import RIBs
import RxRelay
import RxSwift

fileprivate protocol StreamType: AnyObject {
    associatedtype T
    var stream: Observable<T> { get }
    func subscribe(disposedOnDeactivate interactor: Interactor, action: @escaping (T) -> Void)
}

fileprivate protocol MutableStreamType: StreamType {
    func update(withValue value: T)
}

class Stream<T: Equatable>: StreamType {

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

final class MutableStream<T: Equatable>: Stream<T>, MutableStreamType {
    
    func update(withValue value: T) {
        relay.accept(value)
    }
}
