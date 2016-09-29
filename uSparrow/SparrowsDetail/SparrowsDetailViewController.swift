//
//  SparrowsDetailViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/29.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowsDetailViewController: UIViewController {
    var startingIndex = 0
    @IBOutlet weak var thumbnailCollectionView: UICollectionView!
    var sparrowThumbnails: [UIImage]!
    @IBOutlet weak var sparrowPhotoCropView: SparrowPhotoCropView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        sparrowPhotoCropView.layer.shadowColor   = UIColor.black.cgColor
//        sparrowPhotoCropView.layer.shadowRadius  = 30.0
//        sparrowPhotoCropView.layer.shadowOpacity = 0.9
//        sparrowPhotoCropView.layer.shadowOffset  = CGSize.zero
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        thumbnailCollectionView.performBatchUpdates(nil) { [weak weakSelf = self] _ in
            let startingIndexPath = IndexPath(row: (weakSelf?.startingIndex)!, section: 0)
            weakSelf?.sparrowPhotoCropView.image = weakSelf?.sparrowThumbnails[(weakSelf?.startingIndex)!]
            weakSelf?.thumbnailCollectionView.selectItem(at: startingIndexPath, animated: false, scrollPosition: .centeredHorizontally)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
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
}

// MARK: UICollectionViewDelegate

extension SparrowsDetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        sparrowPhotoCropView.image = sparrowThumbnails[indexPath.row]
    }
}

// MARK: UICollectionViewDelegateFlowLayout

fileprivate let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
fileprivate let itemsPerRow: CGFloat = 1

extension SparrowsDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.height - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
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
}
