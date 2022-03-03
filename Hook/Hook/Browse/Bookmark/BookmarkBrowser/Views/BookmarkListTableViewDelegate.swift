//
//  BookmarkListTableViewDelegate.swift
//  Hook
//
//  Created by Yeojin Yoon on 2022/02/23.
//

import UIKit

final class BookmarkListTableViewDelegate: NSObject, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return UITableView.automaticDimension }
        return 100
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 96
    }
}
