//
//  TagRepository.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/01/05.
//

import CoreData

protocol TagRepositoryType {
    func isExisting(_ tag: Tag) -> Bool
    func add(_ tag: Tag) -> Result<Void, Error>
    func update(_ tag: Tag, to newTag: Tag) -> Result<Void, Error>
    func update(tags: [Tag]) -> Result<Void, Error>
    func clear()
}

final class TagRepository: TagRepositoryType {
    
    static let shared = TagRepository()
    
    private let mutableTagsStream = MutableStream<[Tag]>(initialValue: [])
    
    private var context: NSManagedObjectContext { PersistentContainer.shared.context }
    
    var tagsStream: ReadOnlyStream<[Tag]> { mutableTagsStream }
    
    private init() { fetch() }
    
    func isExisting(_ tag: Tag) -> Bool {
        return mutableTagsStream.value.contains { $0.name.caseInsensitiveCompare(tag.name) == .orderedSame }
    }
    
    func add(_ tag: Tag) -> Result<Void, Error> {
        let request = TagStorage.fetchRequest()
        do {
            guard let tagStorage = try context.fetch(request).first else { return .success(()) }
            let tags = tagStorage.tags ?? []
            tagStorage.tags = tags.appended(with: TagEntity(name: tag.name))
            try context.save()
            let newValue = mutableTagsStream.value.appended(with: tag)
            mutableTagsStream.update(with: newValue)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(_ tag: Tag, to newTag: Tag) -> Result<Void, Error> {
        if tag.name == newTag.name { return .success(()) }
        guard let tags = makeReplacedTags(tag, with: newTag) else { return .success(()) }
        let request = TagStorage.fetchRequest()
        do {
            guard let tagStorage = try context.fetch(request).first else { return .success(()) }
            tagStorage.tags = tags.map { $0.converted() }
            try context.save()
            mutableTagsStream.update(with: tags)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func update(tags: [Tag]) -> Result<Void, Error> {
        let request = TagStorage.fetchRequest()
        do {
            guard let tagStorage = try context.fetch(request).first else { return .success(()) }
            tagStorage.tags = tags.map { $0.converted() }
            try context.save()
            mutableTagsStream.update(with: tags)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func clear() {
        let request = TagStorage.fetchRequest()
        do {
            guard let tagStorage = try context.fetch(request).first else { return }
            tagStorage.tags = [TagEntity(name: TagName.all)]
            try context.save()
            mutableTagsStream.update(with: [Tag(name: TagName.all)])
        } catch {
            return
        }
    }
    
    private func fetch() {
        let request = TagStorage.fetchRequest()
        guard let tags = try? context.fetch(request).first?.extractTags() else {
            setUp()
            return
        }
        mutableTagsStream.update(with: tags)
    }
    
    private func setUp() {
        let tagStorage = TagStorage(context: context)
        tagStorage.tags = [TagEntity(name: TagName.all)]
        try? context.save()
        mutableTagsStream.update(with: [Tag(name: TagName.all)])
    }
    
    private func makeReplacedTags(_ tag: Tag, with newTag: Tag) -> [Tag]? {
        var tags = mutableTagsStream.value
        guard let index = tags.firstIndex(of: tag) else { return nil }
        tags[index] = newTag
        return tags
    }
}
