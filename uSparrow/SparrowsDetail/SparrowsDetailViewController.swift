//
//  SparrowsDetailViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/29.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowsDetailViewController: UIViewController {
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    @IBOutlet weak var sparrowPhotoCropView: SparrowPhotoCropView!
    
    var largePhotoIndexPath: IndexPath? {
        didSet {
            if let largePhotoIndexPath = self.largePhotoIndexPath {
                startingIndex = largePhotoIndexPath.row
            }
            guard isViewLoaded else {
                return
            }
            if let largePhotoIndexPath = self.largePhotoIndexPath {
                updateThumbnailCollectionView(indexPath: largePhotoIndexPath, animated: true)
            }
        }
    }
    
    let widthPerItem: CGFloat = 30
    let widthSelectedItem: CGFloat = 86
    var sparrowThumbnails: [UIImage]!
    fileprivate var startingIndex = 0 {
        didSet {
            let titleString = String(startingIndex + 1)
            title = "("+titleString+"/"+String(sparrowThumbnails.count)+")"
            if isViewLoaded {
                sparrowPhotoCropView.image = sparrowThumbnails[startingIndex]
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thumbnailCollectionView.backgroundColor = Constants.SparrowTheme.backgroundColor
        if let largePhotoIndexPath = self.largePhotoIndexPath {
            sparrowPhotoCropView.image = sparrowThumbnails[largePhotoIndexPath.row]
            updateThumbnailCollectionView(indexPath: largePhotoIndexPath, animated: false)
        }
    }
    
    fileprivate func updateThumbnailCollectionView(indexPath: IndexPath, animated: Bool) {
        thumbnailCollectionView.performBatchUpdates(nil) { completed in
            self.thumbnailCollectionView.selectItem(at: indexPath, animated: animated, scrollPosition: .centeredHorizontally)
        }
    }
}

// MARK: UICollectionViewDataSource

extension SparrowsDetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sparrowThumbnails.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuserIdentifier.uSparrowsThumbnailCell, for: indexPath) as? ThumbnailCell {
            cell.thumbnailImageView.image = sparrowThumbnails[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ReuserIdentifier.uSparrowImageDetailHeaderView, for: indexPath) as! SparrowImageDetailReusableView
            return headerView
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ReuserIdentifier.uSparrowImageDetailFooterView, for: indexPath) as! SparrowImageDetailReusableView
            return footerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
}

// MARK: UICollectionViewDelegate

extension SparrowsDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        largePhotoIndexPath = indexPath
    }
}

// MARK: UICollectionViewDelegateFlowLayout

fileprivate let leftInset: CGFloat = 2.0
fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: leftInset, bottom: 5.0, right: leftInset)
fileprivate let itemsPerRow: CGFloat = 1

extension SparrowsDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableHeight = collectionView.frame.height - paddingSpace
        let heightPerItem = availableHeight / itemsPerRow
        if indexPath == largePhotoIndexPath {
            return CGSize(width: widthSelectedItem, height: heightPerItem)
        }
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width/2, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width/2, height: collectionView.frame.height)
    }
    
}

extension SparrowsDetailViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let largePhotoIndexPath = self.largePhotoIndexPath {
            thumbnailCollectionView.deselectItem(at: largePhotoIndexPath, animated: false)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let x = (scrollView.contentOffset.x - leftInset/2)/( widthPerItem + leftInset)
        let y = max(0, min(Int(round(x)) - 1, sparrowThumbnails.count - 1))
        if let largePhotoIndexPath = self.largePhotoIndexPath {
            startingIndex = largePhotoIndexPath.row
        }
        guard startingIndex != y else {
            return
        }
        startingIndex = y
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print(#function)
        if !decelerate {
            largePhotoIndexPath = IndexPath(row: startingIndex, section: 0)
        } else {
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print(#function)
        largePhotoIndexPath = IndexPath(row: startingIndex, section: 0)
    }
    
}
