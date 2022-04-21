//
//  ShareBuilder.swift
//  ShareExtension
//
//  Created by Yeojin Yoon on 2022/04/19.
//

import RIBs

protocol ShareDependency: Dependency {
    var baseViewController: ShareViewControllable { get }
}

final class ShareComponent: Component<ShareDependency>, ShareInteractorDependency, SelectTagsDependency, SearchTagsDependency {
    
    fileprivate var baseViewController: ShareViewControllable { dependency.baseViewController }
    
    let selectedTagsStream = MutableStream<[Tag]>(initialValue: [])
    let tagBySearchStream = MutableStream<Tag>(initialValue: Tag(name: ""))
}

// MARK: - Builder

protocol ShareBuildable: Buildable {
    func build(withListener listener: ShareListener) -> ShareRouting
}

final class ShareBuilder: Builder<ShareDependency>, ShareBuildable {
    
    override init(dependency: ShareDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: ShareListener) -> ShareRouting {
        let component = ShareComponent(dependency: dependency)
        let interactor = ShareInteractor(dependency: component)
        interactor.listener = listener
        let selectTags = SelectTagsBuilder(dependency: component)
        let searchTags = SearchTagsBuilder(dependency: component)
        return ShareRouter(interactor: interactor,
                           viewController: component.baseViewController,
                           selectTags: selectTags,
                           searchTags: searchTags)
    }
}
