//
//  BookmarkListContextMenuProvider.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/03/10.
//

import UIKit

final class BookmarkListContextMenuProvider {
    
    private weak var listener: BookmarkListCollectionViewListener?
    private var bookmark: Bookmark?
    
    init(listener: BookmarkListCollectionViewListener?) {
        self.listener = listener
    }
    
    func menu(for bookmark: Bookmark?) -> UIMenu {
        self.bookmark = bookmark
        return UIMenu(title: "", children: [shareAction(), copyLinkAction(), favoriteAction(), editAction(), deleteAction()])
    }
    
    private func shareAction() -> UIAction {
        return UIAction(title: LocalizedString.ActionTitle.share, image: UIImage(systemName: "square.and.arrow.up")) { _ in
            guard let bookmark = self.bookmark else { return }
            self.listener?.contextMenuShareDidTap(bookmark: bookmark)
        }
    }
    
    private func copyLinkAction() -> UIAction {
        return UIAction(title: LocalizedString.ActionTitle.copyLink, image: UIImage(systemName: "link")) { _ in
            guard let bookmark = self.bookmark else { return }
            self.listener?.contextMenuCopyLinkDidTap(bookmark: bookmark)
        }
    }
    
    private func favoriteAction() -> UIAction {
        let isFavorite = bookmark?.isFavorite ?? false
        let title = isFavorite ? LocalizedString.ActionTitle.removeFromFavorites : LocalizedString.ActionTitle.addToFavorites
        let image = isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark")
        return UIAction(title: title, image: image) { _ in
            guard let bookmark = self.bookmark else { return }
            self.listener?.contextMenuFavoriteDidTap(bookmark: bookmark)
        }
    }
    
    private func editAction() -> UIAction {
        return UIAction(title: LocalizedString.ActionTitle.edit, image: UIImage(systemName: "pencil")) { _ in
            guard let bookmark = self.bookmark else { return }
            self.listener?.contextMenuEditDidTap(bookmark: bookmark)
        }
    }
    
    private func deleteAction() -> UIAction {
        return UIAction(title: LocalizedString.ActionTitle.delete, image: UIImage(systemName: "minus.circle"), attributes: .destructive) { _ in
            guard let bookmark = self.bookmark else { return }
            self.listener?.contextMenuDeleteDidTap(bookmark: bookmark)
        }
    }
}
