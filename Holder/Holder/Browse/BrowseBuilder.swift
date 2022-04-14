//
//  BrowseBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/02.
//

import RIBs

protocol BrowseDependency: Dependency {}

final class BrowseComponent: Component<BrowseDependency>, TagDependency, BookmarkDependency {
    
    let currentTagStream = MutableStream<Tag>(initialValue: Tag(name: ""))
    let selectedTagsStream = MutableStream<[Tag]>(initialValue: [])
    let baseViewController: BrowseViewControllable
    
    init(dependency: BrowseDependency, baseViewController: BrowseViewControllable) {
        self.baseViewController = baseViewController
        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol BrowseBuildable: Buildable {
    func build(withListener listener: BrowseListener) -> BrowseRouting
}

final class BrowseBuilder: Builder<BrowseDependency>, BrowseBuildable {

    override init(dependency: BrowseDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: BrowseListener) -> BrowseRouting {
        let viewController = BrowseViewController()
        let component = BrowseComponent(dependency: dependency, baseViewController: viewController)
        let interactor = BrowseInteractor(presenter: viewController)
        interactor.listener = listener
        let tag = TagBuilder(dependency: component)
        let bookmark = BookmarkBuilder(dependency: component)
        return BrowseRouter(interactor: interactor,
                            viewController: viewController,
                            tag: tag,
                            bookmark: bookmark)
    }
}
