//
//  LocalizedString.swift
//  Hook
//
//  Created by Yeojin Yoon on 2021/12/29.
//

import Foundation

enum LocalizedString {
    enum ActionTitle {
        static let add = "Add".localized
        static let addToFavorites = "Add to Favorites".localized
        static let appearanceSettings = "Appearance Settings".localized
        static let cancel = "Cancel".localized
        static let clear = "Clear".localized
        static let copyLink = "Copy Link".localized
        static let dark = "Dark".localized
        static let delete = "Delete".localized
        static let done = "Done".localized
        static let edit = "Edit".localized
        static let light = "Light".localized
        static let newestToOldest = "Newest to Oldest".localized
        static let ok = "OK".localized
        static let oldestToNewest = "Oldest to Newest".localized
        static let reload = "Reload".localized
        static let removeFromFavorites = "Remove from Favorites".localized
        static let save = "Save".localized
        static let share = "Share".localized
        static let signOut = "Sign Out".localized
        static let systemSetting = "System Setting".localized
    }
    
    enum AlertTitle {
        static let enterTheLink = "Enter the link.".localized
        static let bookmarkCorrespondingToTheLinkExists = "A bookmark corresponding to the link exists.".localized
        static let errorOccurredWhileFetchingTheMetadata = "An error occurred while fetching the metadata.".localized
        static let errorOccurredWhileCheckingTheStore = "An error occurred while checking the store.".localized
        static let errorOccurredWhileSavingToTheStore = "An error occurred while saving to the store.".localized
        static let keychainErrorOccured = "Keychain Error Occured".localized
        static let tagAlreadySelected = "Tag Already Selected".localized
        static let deleteBookmark = "Delete Bookmark?".localized
    }
    
    enum AlertMessage {
        static let keychainErrorOccured = "An error occurred while saving to the keychain.".localized
        static let tagAlreadySelected = "Check out the tag in the list.".localized
        static let deleteBookmark = "This bookmark will be deleted from all tags.".localized
    }
    
    enum LabelText {
        static let tagName = "Tag name".localized
        static let link = "Link".localized
        static let tags = "Tags".localized
        static let note = "Note".localized
        static let recentSearches = "Recent Searches".localized
        static let noRecentSearches = "No Recent Searches".localized
        static let noRecentSearchesExplanation = "Recent searches will be added as you search for titles, links, or notes.".localized
        static let noSearchResults = "No Search Results".localized
        static let noSearchResultsExplanation = "No results matching the search term could be found. Try another search term.".localized
        static let noFavorites = "No Favorites".localized
        static let noFavoritesExplanation = "There are no bookmarks added to Favorites. Add frequently used bookmarks.".localized
    }
    
    enum Placeholder {
        static let searchAndAdd = "Search & Add".localized
        static let searchTitlesLinksNotes = "Search titles, links, notes".localized
    }
    
    enum TagName {
        static let all = "All".localized
    }
    
    enum ViewTitle {
        static let browse = "Browse".localized
        static let search = "Search".localized
        static let favorites = "Favorites".localized
        static let settings = "Settings".localized
        static let tagSettings = "Tag Settings".localized
        static let addTag = "Add Tag".localized
        static let editTag = "Edit Tag".localized
        static let editTags = "Edit Tags".localized
        static let selectTags = "Select Tags".localized
        static let addBookmark = "Add Bookmark".localized
        static let editBookmark = "Edit Bookmark".localized
        static let appearance = "Appearance".localized
        static let sortBookmarks = "Sort Bookmarks".localized
        static let clearData = "Clear Data".localized
    }
}
