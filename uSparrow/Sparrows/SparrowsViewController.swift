//
//  SparrowsViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit
import ImagePicker

class SparrowsViewController: UICollectionViewController {
    var documentsUrl: URL?
    var sparrows: [Sparrow]!
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = Constants.Color.sparrowBackgroundColor
        reloadCollectionData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func reloadCollectionData() {
        if let url = documentsUrl {
            title = url.lastPathComponent
            sparrows = SparrowFileManager.shared.loadDocumentsData(with: url)
        } else {
            title = "uSparrow"
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            sparrows = SparrowFileManager.shared.loadDocumentsData(with: url)
        }
    }
    
    @IBOutlet weak var setting: UIBarButtonItem!
    @IBAction func setting(_ sender: AnyObject) {
        let v = SparrowAuthViewController()
        present(v, animated: false, completion: nil)
    }
    
    @IBAction func add(_ sender: AnyObject) {
        let alert = UIAlertController(title: "", message: "添加新的文件", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "相机/相册", style: .default, handler: { (action: UIAlertAction!) in
            let imagePickerController = ImagePickerController()
            imagePickerController.delegate = self
            self.present(imagePickerController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "连接局域网", style: .default, handler: { (action: UIAlertAction!) in
            self.performSegue(withIdentifier: Constants.SegueIdentifier.ShowUpload, sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == Constants.SegueIdentifier.ShowSparrowFold {
            if let indexPath = collectionView?.indexPathsForSelectedItems?[0] {
                if indexPath.section > 1 {
                    return false
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.ShowUpload {
            if let nav = segue.destination as? UINavigationController {
                if let upload = nav.viewControllers.first as? UploadViewController {
                    upload.delegate = self
                }
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowSparrowFold {
            if let sparrowsVC = segue.destination as? SparrowsViewController {
                if let indexPath = collectionView?.indexPathsForSelectedItems?[0]{
                    if indexPath.section == 0 {
                        sparrowsVC.documentsUrl = sparrows.filter{ $0.type == SparrowType.uSystem }[indexPath.row].documentsUrl
                    } else if indexPath.section == 1{
                        sparrowsVC.documentsUrl = sparrows.filter{ $0.type == SparrowType.uFold }[indexPath.row].documentsUrl
                    }
                }
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowPhotos {
            if let detail = segue.destination as? SparrowsDetailViewController, let indexPath = sender as? IndexPath {
                detail.sparrowThumbnails = sparrows.filter{ $0.type == SparrowType.uPhoto }.map{ $0.thumbnailPhoto! }
                detail.largePhotoIndexPath = IndexPath(row: indexPath.row, section: 0)
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowGif {
            if let gifPageVC = segue.destination as? SparrowGifContainerViewController, let indexPath = sender as? IndexPath {
                gifPageVC.startingIndex = indexPath.row
                gifPageVC.gifUrls = sparrows.filter{ $0.type == SparrowType.uGif }.map{ $0.documentsUrl!
                }
            }
        }  else if segue.identifier == Constants.SegueIdentifier.ShowText {
            if let textVC = segue.destination as? SparrowTextDetailViewController, /*let url = sender as? URL*/ let text = sender as? String {
                textVC.text = text
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowWeb {
            if let webVC = segue.destination as? SparrowWebViewController, let url = sender as? URL {
                webVC.webUrl = url
            }
        }
    }
    
    
}

// MARK: UICollectionViewDataSource && UICollectionViewDelegate

extension SparrowsViewController {
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sparrows.filter{ $0.type.usn == section }.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuserIdentifier.uSparrowCell, for: indexPath) as? SparrowCell {
            cell.sparrow = sparrows.filter{ $0.type.usn == indexPath.section }[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ReuserIdentifier.uSparrowsHeaderView, for: indexPath) as! SparrowsHeaderView
            switch indexPath.section {
            case 0:
                headerView.sparrowsHeaderLabel.text = "默认文件夹(" + String(sparrows.filter{ $0.type == SparrowType.uSystem }.count) + ")"
            case 1:
                headerView.sparrowsHeaderLabel.text = "自定义文件夹(" + String(sparrows.filter{ $0.type == SparrowType.uFold }.count) + ")"
            case 2:
                headerView.sparrowsHeaderLabel.text = "图片(" + String(sparrows.filter{ $0.type == SparrowType.uPhoto }.count) + ")"
            case 3:
                headerView.sparrowsHeaderLabel.text = "GIF(" + String(sparrows.filter{ $0.type == SparrowType.uGif }.count) + ")"
            case 4:
                headerView.sparrowsHeaderLabel.text = "视频(" + String(sparrows.filter{ $0.type == SparrowType.uVideo }.count) + ")"
            case 5:
                headerView.sparrowsHeaderLabel.text = "文本(" + String(sparrows.filter{ $0.type == SparrowType.uDoc }.count) + ")"
            case 6:
                headerView.sparrowsHeaderLabel.text = "其他(" + String(sparrows.filter{ $0.type == SparrowType.uOthers }.count) + ")"
            default:
                break
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            print("choose the system fold, should perform segue from cell")
        case 1:
            print("choose the custom fold, should perform segue from cell")
        case 2:
            performSegue(withIdentifier: Constants.SegueIdentifier.ShowPhotos, sender: indexPath)
        case 3:
            performSegue(withIdentifier: Constants.SegueIdentifier.ShowGif, sender: indexPath)
        case 4:
            let videos = sparrows.filter{ $0.type == SparrowType.uVideo }
            if let url = videos[indexPath.row].documentsUrl {
                let player = AVPlayer(url: url)
                let playerController = AVPlayerViewController()
                playerController.player = player
                self.present(playerController, animated: true) {
                    player.play()
                }
            }
        case 5:
            let texts = sparrows.filter{ $0.type == SparrowType.uDoc }
            if let url = texts[indexPath.row].documentsUrl {
                if url.pathExtension == "txt" || url.pathExtension == "TXT" {
                    DispatchQueue.global().async {
                        do {
                            let text = try String(contentsOf: url, encoding: String.Encoding.utf8)
                            print(text)
                            DispatchQueue.main.async {
                                self.performSegue(withIdentifier: Constants.SegueIdentifier.ShowText, sender: text)
                                print("segue")
                            }
                        } catch let err {
                            print(err.localizedDescription)
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "提示", message: err.localizedDescription, preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "知道了", style: .cancel, handler: { (action: UIAlertAction!) in
                                }))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                } else if url.pathExtension == "pdf" || url.pathExtension == "PDF" {
                    performSegue(withIdentifier: Constants.SegueIdentifier.ShowWeb, sender: url)
                }
            }
        case 6:
            let others = sparrows.filter{ $0.type == SparrowType.uOthers }
            if let url = others[indexPath.row].documentsUrl {
                let alert = UIAlertController(title: "提示", message: "暂时无法预览"+url.lastPathComponent+"，您可以在连接局域网之后，将文件下载到电脑中", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "连接局域网", style: .default, handler: { (action: UIAlertAction!) in
                    self.performSegue(withIdentifier: Constants.SegueIdentifier.ShowUpload, sender: nil)
                }))
                alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: { (action: UIAlertAction!) in
                }))
                present(alert, animated: true, completion: nil)
            }
            
        default:
            break
        }
    }
    
    func emmmmmm() {
        
        // MARK: UICollectionViewDelegate
        
        /*
         // Uncomment this method to specify if the specified item should be highlighted during tracking
         override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment this method to specify if the specified item should be selected
         override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
         override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
         
         }
         */
    }
    
}

// MARK: UICollectionViewDelegateFlowLayout

fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 2.0, bottom: 0.0, right: 2.0)
fileprivate let itemsPerRow: CGFloat = 4
fileprivate let headerHeight: CGFloat = 50

extension SparrowsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let temp = sparrows.filter{ $0.type.usn == section }
        guard !temp.isEmpty else {
            return CGSize.zero
        }
        return CGSize(width: collectionView.bounds.width, height: headerHeight)
    }
    
}

// MARK: UploadViewControllerDelegate

extension SparrowsViewController: UploadViewControllerDelegate {
    func uploadViewController(_ controller: UploadViewController, didCancelNeedUpdate isNeedUpdate: Bool) {
        dismiss(animated: true) {
            guard isNeedUpdate else {
                return
            }
            self.collectionView?.performBatchUpdates({
                self.reloadCollectionData()
                }, completion: { (isSuccess: Bool) in
            })
        }
    }
}

extension SparrowsViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print(images)
        dismiss(animated: true)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        _ = images.map{ SparrowFileManager.shared.saveFileToSparrowSystem(image: $0) }
        dismiss(animated: true)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController){
        dismiss(animated: true)
    }
    
}
