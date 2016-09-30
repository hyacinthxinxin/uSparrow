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

class SparrowsViewController: UICollectionViewController, UINavigationControllerDelegate {
    var documentsUrl: URL?
    var sparrows: [Sparrow]!
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.clearsSelectionOnViewWillAppear = false
        if let url = documentsUrl {
            loadCollectionViewData(with: url)
        } else {
            loadCollectionViewData(with: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    fileprivate func loadCollectionViewData(with documentsUrl: URL) {
        sparrows = [Sparrow]()
        let fileManager = FileManager.default
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            sparrows = directoryContents.map {
                let sparrow = Sparrow(documentsUrl: $0)
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: $0.path, isDirectory:&isDir) {
                    if isDir.boolValue {
                        sparrow.type = SparrowType.uFold
                    } else {
                        sparrow.type = Sparrow.getSparrowType(with: $0.pathExtension)
                    }
                    sparrow.setTumbnailPhoto()
                }
                return sparrow
            }
            /*
             let jpgFiles = directoryContents.filter{ $0.pathExtension == "jpg" }
             print("jpg urls:",jpgFiles)
             sparrowImages = jpgFiles.map {
             if let imageData = NSData(contentsOf: $0), let image = UIImage(data: imageData as Data) {
             return image
             }
             return UIImage()
             }
             
             let jpgFileNames = jpgFiles.map{ $0.deletingPathExtension().lastPathComponent }
             print("jpg list:", jpgFileNames)
             */
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func add(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Contact", message: "Add a new friend", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "from 相机", style: .default, handler: { (action: UIAlertAction!) in
            print("from 相机")
        }))
        alert.addAction(UIAlertAction(title: "from 相册", style: .default, handler: { (action: UIAlertAction!) in
            print("from 相册")
            self.selectImage(from: UIImagePickerControllerSourceType.photoLibrary)
        }))
        
        alert.addAction(UIAlertAction(title: "from 局域网", style: .default, handler: { (action: UIAlertAction!) in
            print("from 局域网")
            self.performSegue(withIdentifier: Constants.SegueIdentifier.ShowUpload, sender: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "取消", style: .default, handler: { (action: UIAlertAction!) in
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    private func selectImage(from source: UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = source
            picker.mediaTypes = [kUTTypeImage as String, kUTTypeGIF as String, kUTTypeVideo as String]
            self.present(picker, animated: true, completion: {
                //
            })
        } else {
            print("not available")
        }
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
                    sparrowsVC.documentsUrl = sparrows.filter{ $0.type == SparrowType.uFold }[indexPath.row].documentsUrl
                }
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowPhotos {
            if let detail = segue.destination as? SparrowsDetailViewController, let indexPath = sender as? IndexPath {
                detail.sparrowThumbnails = sparrows.filter{ $0.type == SparrowType.uPhoto }.map{ $0.thumbnailPhoto! }
                detail.startingIndex = indexPath.row
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowGif {
            if let gifPageVC = segue.destination as? SparrowGifPageViewController, let indexPath = sender as? IndexPath {
                gifPageVC.startingIndex = indexPath.row
                gifPageVC.gifUrls = sparrows.filter{ $0.type == SparrowType.uGif }.map{ $0.documentsUrl! }
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
        switch section {
        case 0:
            return sparrows.filter{ $0.type == SparrowType.uSystem }.count
        case 1:
            return sparrows.filter{ $0.type == SparrowType.uFold }.count
        case 2:
            return sparrows.filter{ $0.type == SparrowType.uPhoto }.count
        case 3:
            return sparrows.filter{ $0.type == SparrowType.uGif }.count
        case 4:
            return sparrows.filter{ $0.type == SparrowType.uVideo }.count
        case 5:
            return sparrows.filter{ $0.type == SparrowType.uText }.count
        case 6:
            return sparrows.filter{ $0.type == SparrowType.uOthers }.count
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuserIdentifier.uSparrowCell, for: indexPath) as? SparrowCell {
            switch indexPath.section {
            case 0:
                cell.sparrow = sparrows.filter{ $0.type == SparrowType.uSystem }[indexPath.row]
            case 1:
                cell.sparrow = sparrows.filter{ $0.type == SparrowType.uFold }[indexPath.row]
            case 2:
                cell.sparrow = sparrows.filter{ $0.type == SparrowType.uPhoto }[indexPath.row]
            case 3:
                cell.sparrow = sparrows.filter{ $0.type == SparrowType.uGif }[indexPath.row]
            case 4:
                cell.sparrow = sparrows.filter{ $0.type == SparrowType.uVideo }[indexPath.row]
            case 5:
                cell.sparrow = sparrows.filter{ $0.type == SparrowType.uText }[indexPath.row]
            case 6:
                cell.sparrow = sparrows.filter{ $0.type == SparrowType.uOthers }[indexPath.row]
            default:
                break;
            }
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
                headerView.backgroundColor = UIColor.blue
            case 2:
                headerView.sparrowsHeaderLabel.text = "图片(" + String(sparrows.filter{ $0.type == SparrowType.uPhoto }.count) + ")"
                headerView.backgroundColor = UIColor.red
            case 3:
                headerView.sparrowsHeaderLabel.text = "GIF(" + String(sparrows.filter{ $0.type == SparrowType.uGif }.count) + ")"
            case 4:
                headerView.sparrowsHeaderLabel.text = "视频(" + String(sparrows.filter{ $0.type == SparrowType.uVideo }.count) + ")"
            case 5:
                headerView.sparrowsHeaderLabel.text = "文本(" + String(sparrows.filter{ $0.type == SparrowType.uText }.count) + ")"
                headerView.backgroundColor = UIColor.blue
            case 6:
                headerView.sparrowsHeaderLabel.text = "其他(" + String(sparrows.filter{ $0.type == SparrowType.uOthers }.count) + ")"
                headerView.backgroundColor = UIColor.red
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
            print("choose the system fold")
        case 1:
            print("choose the custom fold")
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
            print("choose text")
        case 6:
            print("choose others")
        default:
            break
        }
    }
    
    
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

// MARK: UICollectionViewDelegateFlowLayout

fileprivate let sectionInsets = UIEdgeInsets(top: 5.0, left: 2.0, bottom: 5.0, right: 2.0)
fileprivate let itemsPerRow: CGFloat = 4

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
    
    /*
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
     
     return CGSize.zero
     }
     */
}

// MARK: UploadViewControllerDelegate

extension SparrowsViewController: UploadViewControllerDelegate {
    func uploadViewController(_ controller: UploadViewController, didCancelNeedUpdate isNeedUpdate: Bool) {
        dismiss(animated: true) {
            guard isNeedUpdate else {
                return
            }
            if let url = self.documentsUrl {
                self.loadCollectionViewData(with: url)
            } else {
                self.loadCollectionViewData(with: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
            }
            self.collectionView?.reloadData()
        }
    }
}

extension SparrowsViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let mediaType = info[UIImagePickerControllerMediaType] as? NSString {
            if mediaType.isEqual(to: kUTTypeImage as String) {
                print("is image")
            }
            if mediaType.isEqual(to: kUTTypeVideo as String) {
                print("is video")
                if let urlOfVideo = info[UIImagePickerControllerMediaURL] as? NSURL{
                    print(urlOfVideo)
                }
            }
        }
        
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        print(chosenImage)
        //        myImageView.contentMode = .ScaleAspectFit //3
        //        myImageView.image = chosenImage //4
        picker.dismiss(animated: true) {
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
}
