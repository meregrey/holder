//
//  TagBuilder.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs

protocol TagDependency: Dependency {
    var currentTagStream: MutableStream<Tag> { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
    var baseViewController: BrowseViewControllable { get }
}

final class TagComponent: Component<TagDependency>, TagBarDependency, TagSettingsDependency, EnterTagDependency, EditTagsDependency, SelectTagsDependency, SearchTagsDependency {
    
    let tagBySearchStream: MutableStream<Tag> = MutableStream<Tag>(initialValue: Tag(name: ""))
    
    var currentTagStream: MutableStream<Tag> { dependency.currentTagStream }
    var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
    fileprivate var baseViewController: BrowseViewControllable { dependency.baseViewController }
}

// MARK: - Builder

protocol TagBuildable: Buildable {
    func build(withListener listener: TagListener) -> TagRouting
}

final class TagBuilder: Builder<TagDependency>, TagBuildable {
    
    override init(dependency: TagDependency) {
        super.init(dependency: dependency)
    }
    
    func build(withListener listener: TagListener) -> TagRouting {
        let component = TagComponent(dependency: dependency)
        let interactor = TagInteractor()
        interactor.listener = listener
        let tagBar = TagBarBuilder(dependency: component)
        let tagSettings = TagSettingsBuilder(dependency: component)
        let enterTag = EnterTagBuilder(dependency: component)
        let editTags = EditTagsBuilder(dependency: component)
        let selectTags = SelectTagsBuilder(dependency: component)
        let searchTags = SearchTagsBuilder(dependency: component)
        return TagRouter(interactor: interactor,
                         baseViewController: component.baseViewController,
                         tagBar: tagBar,
                         tagSettings: tagSettings,
                         enterTag: enterTag,
                         editTags: editTags,
                         selectTags: selectTags,
                         searchTags: searchTags)
    }
}
