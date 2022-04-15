//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Yeojin Yoon on 2022/04/15.
//

import Social
import UIKit

final class ShareViewController: SLComposeServiceViewController {
    
    override func isContentValid() -> Bool {
        return true
    }
    
    override func didSelectPost() {
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override func configurationItems() -> [Any]! {
        return []
    }
}
