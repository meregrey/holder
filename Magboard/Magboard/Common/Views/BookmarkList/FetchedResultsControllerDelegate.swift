//
//  FetchedResultsControllerDelegate.swift
//  Magboard
//
//  Created by Yeojin Yoon on 2022/02/24.
//

import CoreData
import UIKit

final class FetchedResultsControllerDelegate: NSObject, NSFetchedResultsControllerDelegate {
    
    private weak var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            DispatchQueue.main.async {
                guard let newIndexPath = newIndexPath else { return }
                self.collectionView?.insertItems(at: [newIndexPath])
            }
        case .update:
            DispatchQueue.main.async {
                guard let indexPath = indexPath else { return }
                self.collectionView?.reloadItems(at: [indexPath])
            }
        case .delete:
            DispatchQueue.main.async {
                guard let indexPath = indexPath else { return }
                self.collectionView?.deleteItems(at: [indexPath])
            }
        default: break
        }
    }
}
