//
//  EnterBookmarkBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/27.
//

import RIBs

protocol EnterBookmarkDependency: Dependency {
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class EnterBookmarkComponent: Component<EnterBookmarkDependency>, EnterBookmarkInteractorDependency {
    
    let mode: EnterBookmarkMode
    
    var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
    init(dependency: EnterBookmarkDependency, mode: EnterBookmarkMode) {
        self.mode = mode
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol EnterBookmarkBuildable: Buildable {
    func build(withListener listener: EnterBookmarkListener, mode: EnterBookmarkMode) -> EnterBookmarkRouting
}

final class EnterBookmarkBuilder: Builder<EnterBookmarkDependency>, EnterBookmarkBuildable {
    
    override init(dependency: EnterBookmarkDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: EnterBookmarkListener, mode: EnterBookmarkMode) -> EnterBookmarkRouting {
        let component = EnterBookmarkComponent(dependency: dependency, mode: mode)
        let viewController = EnterBookmarkViewController(mode: mode)
        let interactor = EnterBookmarkInteractor(presenter: viewController, dependency: component)
        interactor.listener = listener
        return EnterBookmarkRouter(interactor: interactor, viewController: viewController)
    }
}
