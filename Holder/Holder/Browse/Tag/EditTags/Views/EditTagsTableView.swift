//
//  EditTagsTableView.swift
//  Holder
//
//  Created by Yeojin Yoon on 2022/01/17.
//

import UIKit

final class EditTagsTableView: UITableView {
    
    override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)
        if subview.description.contains("Shadow") { subview.isHidden = true }
    }
}
