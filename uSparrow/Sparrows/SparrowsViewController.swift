//
//  SparrowsViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import MobileCoreServices

class SparrowsViewController: UICollectionViewController, UINavigationControllerDelegate {
    var documentsUrl: URL?
    var sparrowFolds: [SparrowFold]!
    var sparrowImages: [UIImage]!
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.clearsSelectionOnViewWillAppear = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = documentsUrl {
            loadCollectionViewData(with: url)
        } else {
            loadCollectionViewData(with: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
        }
    }
    
    fileprivate func loadCollectionViewData(with documentsUrl: URL) {
        sparrowFolds = [SparrowFold(name:"相册")]
        sparrowImages = [UIImage]()
        let fileManager = FileManager.default
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            for url in directoryContents {
                var isDir : ObjCBool = false
                if fileManager.fileExists(atPath: url.path, isDirectory:&isDir) {
                    if isDir.boolValue {
//                        print("file exists and is a directory")
                        let f = SparrowFold()
                        f.documentsUrl = url
                        f.name = url.lastPathComponent
                        sparrowFolds.append(f)
                    } else {
//                        print("file exists and is not a directory")
                        if let imageData = NSData(contentsOf: url), let image = UIImage(data: imageData as Data) {
                            sparrowImages.append(image)
                        }
                    }
                } else {
                    print("file does not exist")
                }
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
        /*
         alert.addTextField { (textField: UITextField!) in
         textField.placeholder = "User Id"
         }
         alert.addTextField { (textField: UITextField!) in
         textField.placeholder = "User Name"
         }
         */
        alert.addAction(UIAlertAction(title: "from 相机", style: .default, handler: { (action: UIAlertAction!) in
            print("from 相机")
            self.selectImage(from: UIImagePickerControllerSourceType.camera)
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
            })} else {
            print("not available")
        }
    }
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.ShowUpload {
            if let nav = segue.destination as? UINavigationController {
                if let upload = nav.viewControllers.first as? UploadViewController {
                    upload.delegate = self
                }
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowSparrowFold {
            if let sparrows = segue.destination as? SparrowsViewController {
                if let indexPath = collectionView?.indexPathsForSelectedItems?[0]{
                    sparrows.documentsUrl = sparrowFolds[indexPath.row].documentsUrl
                }
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowSparrow {
            if let sparrow = segue.destination as? SparrowViewController {
                if let indexPath = collectionView?.indexPathsForSelectedItems?[0] {
                    sparrow.sparrowPhoto = sparrowImages[indexPath.row]
                }
            }
        }
    }
    
}

// MARK: UICollectionViewDataSource && UICollectionViewDelegate

extension SparrowsViewController {
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return sparrowFolds.count
        }
        return sparrowImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuserIdentifier.uSparrowFoldCell, for: indexPath) as? SparrowFoldCell {
                let sparrowFold = sparrowFolds[indexPath.row]
                cell.configCell(with: sparrowFold)
                return cell
            }
        } else if indexPath.section == 1 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuserIdentifier.uSparrowCell, for: indexPath) as? SparrowCell {
                cell.sparrowPhoto.image = sparrowImages[indexPath.row]
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: Constants.ReuserIdentifier.uSparrowsHeaderView, for: indexPath) as! SparrowsHeaderView
            if indexPath.section == 0 {
                headerView.sparrowsHeaderLabel.text = "文件夹" + String(sparrowFolds.count)
            } else if indexPath.section == 1 {
                headerView.sparrowsHeaderLabel.text = "图片" + String(sparrowImages.count)
            }
            return headerView
        default:
            assert(false, "Unexpected element kind")
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

fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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
