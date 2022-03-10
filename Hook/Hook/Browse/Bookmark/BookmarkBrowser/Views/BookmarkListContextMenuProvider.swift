//
//  BookmarkListContextMenuProvider.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/03/10.
//

import UIKit

protocol BookmarkListContextMenuListener: AnyObject {
    func contextMenuCopyURLDidTap(bookmarkEntity: BookmarkEntity)
    func contextMenuFavoriteDidTap(bookmarkEntity: BookmarkEntity)
    func contextMenuEditDidTap(bookmarkEntity: BookmarkEntity)
    func contextMenuDeleteDidTap(bookmarkEntity: BookmarkEntity)
}

final class BookmarkListContextMenuProvider {
    
    private weak var listener: BookmarkListContextMenuListener?
    private var bookmarkEntity: BookmarkEntity?
    
    init(listener: BookmarkListContextMenuListener?) {
        self.listener = listener
    }
    
    func menu(for bookmarkEntity: BookmarkEntity?) -> UIMenu {
        self.bookmarkEntity = bookmarkEntity
        return UIMenu(title: "", children: [shareAction(), copyURLAction(), favoriteAction(), editAction(), deleteAction()])
    }
    
    private func shareAction() -> UIAction {
        return UIAction(title: LocalizedString.ActionTitle.share, image: UIImage(systemName: "square.and.arrow.up")) { _ in }
    }
    
    private func copyURLAction() -> UIAction {
        return UIAction(title: LocalizedString.ActionTitle.copyURL, image: UIImage(systemName: "link")) { _ in
            guard let bookmarkEntity = self.bookmarkEntity else { return }
            self.listener?.contextMenuCopyURLDidTap(bookmarkEntity: bookmarkEntity)
        }
    }
    
    private func favoriteAction() -> UIAction {
        let isFavorite = bookmarkEntity?.isFavorite ?? false
        let title = isFavorite ? LocalizedString.ActionTitle.removeFromFavorites : LocalizedString.ActionTitle.addToFavorites
        let image = isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        return UIAction(title: title, image: image) { _ in
            guard let bookmarkEntity = self.bookmarkEntity else { return }
            self.listener?.contextMenuFavoriteDidTap(bookmarkEntity: bookmarkEntity)
        }
    }
    
    private func editAction() -> UIAction {
        return UIAction(title: LocalizedString.ActionTitle.edit, image: UIImage(systemName: "pencil")) { _ in
            guard let bookmarkEntity = self.bookmarkEntity else { return }
            self.listener?.contextMenuEditDidTap(bookmarkEntity: bookmarkEntity)
        }
    }
    
    private func deleteAction() -> UIAction {
        return UIAction(title: LocalizedString.ActionTitle.delete, image: UIImage(systemName: "minus.circle"), attributes: .destructive) { _ in
            guard let bookmarkEntity = self.bookmarkEntity else { return }
            self.listener?.contextMenuDeleteDidTap(bookmarkEntity: bookmarkEntity)
        }
    }
}
