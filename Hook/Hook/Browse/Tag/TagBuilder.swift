//
//  TagBuilder.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/07.
//

import RIBs

protocol TagDependency: Dependency {
    var baseViewController: BrowseViewControllable { get }
    var selectedTagsStream: MutableStream<[Tag]> { get }
}

final class TagComponent: Component<TagDependency>, TagInteractorDependency, TagBarDependency, TagSettingsDependency, EnterTagDependency, EditTagsDependency, SelectTagsDependency, SearchTagsDependency {
    
    fileprivate var baseViewController: BrowseViewControllable { dependency.baseViewController }
    
    let tagBySearchStream = MutableStream<Tag>(initialValue: Tag(name: ""))
    let tagRepository: TagRepositoryType
    
    var tagsStream: ReadOnlyStream<[Tag]> { tagRepository.tagsStream }
    var selectedTagsStream: MutableStream<[Tag]> { dependency.selectedTagsStream }
    
    init(dependency: TagDependency, tagRepository: TagRepositoryType = TagRepository()) {
        self.tagRepository = tagRepository
        super.init(dependency: dependency)
    }
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
        let interactor = TagInteractor(dependency: component)
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
