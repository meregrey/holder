//
//  TagRepository.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import Foundation

protocol TagRepositoryType {
    func fetch()
    func add(tag: Tag)
    func update(tag: Tag, to newTag: Tag)
    func update(tags: [Tag])
}

final class TagRepository: TagRepositoryType {
    
    private let tagsStream: MutableStream<[Tag]>
    private let persistentContainer: PersistentContainerType
    
    private(set) lazy var context = persistentContainer.context
    
    init(tagsStream: MutableStream<[Tag]>, persistentContainer: PersistentContainerType = PersistentContainer()) {
        self.tagsStream = tagsStream
        self.persistentContainer = persistentContainer
        self.fetch()
    }
    
    func fetch() {
        context.perform(with: NotificationName.Tag.didFailToFetchTags) {
            let request = TagStorage.fetchRequest()
            guard let tags = try self.context.fetch(request).first?.extractTags() else {
                self.setUpDefaultTag()
                return
            }
            self.tagsStream.update(with: tags)
        }
    }
    
    func add(tag: Tag) {
        if isExisting(tag) {
            postNotification(ofName: NotificationName.Tag.existingTag)
            return
        }
        context.perform(with: NotificationName.Tag.didFailToAddTag) {
            let request = TagStorage.fetchRequest()
            guard let tagStorage = try self.context.fetch(request).first else { return }
            tagStorage.tags = tagStorage.tags.appended(with: TagEntity(name: tag.name))
            try self.context.save()
            let newTagsStreamValue = self.tagsStream.value.appended(with: tag)
            self.tagsStream.update(with: newTagsStreamValue)
            self.postNotification(ofName: NotificationName.Tag.didSucceedToAddTag)
        }
    }
    
    func update(tag: Tag, to newTag: Tag) {
        if tag.name == newTag.name {
            return
        }
        if isExisting(newTag) {
            postNotification(ofName: NotificationName.Tag.existingTag)
            return
        }
        guard let tags = makeReplacedTags(tag, with: newTag) else { return }
        context.perform(with: NotificationName.Tag.didFailToUpdateTag) {
            let request = TagStorage.fetchRequest()
            guard let tagStorage = try self.context.fetch(request).first else { return }
            tagStorage.tags = tags.map { $0.converted() }
            try self.context.save()
            self.tagsStream.update(with: tags)
        }
    }
    
    func update(tags: [Tag]) {
        context.perform(with: NotificationName.Tag.didFailToUpdateTags) {
            let request = TagStorage.fetchRequest()
            guard let tagStorage = try self.context.fetch(request).first else { return }
            tagStorage.tags = tags.map { $0.converted() }
            try self.context.save()
            self.tagsStream.update(with: tags)
        }
    }
    
    private func setUpDefaultTag() {
        context.perform(with: NotificationName.Tag.didFailToSetUpDefaultTag) {
            let tagStorage = TagStorage(context: self.context)
            tagStorage.tags = [TagEntity(name: TagName.all)]
            try self.context.save()
            self.tagsStream.update(with: [Tag(name: TagName.all)])
        }
    }
    
    private func isExisting(_ tag: Tag) -> Bool {
        return tagsStream.value.contains(tag)
    }
    
    private func postNotification(ofName name: NSNotification.Name, object: Any? = nil) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    private func makeReplacedTags(_ tag: Tag, with newTag: Tag) -> [Tag]? {
        var tags = tagsStream.value
        guard let index = tags.firstIndex(of: tag) else { return nil }
        tags[index] = newTag
        return tags
    }
}
