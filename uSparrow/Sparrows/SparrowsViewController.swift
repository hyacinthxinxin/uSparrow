//
//  SparrowsViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowsViewController: UICollectionViewController {
    var sparrowImages = [UIImage]()
    lazy var foldImage: UIImage = {
        var image = UIImage()
        if let data = NSData(contentsOfFile: Bundle.main.path(forResource: "foldImage", ofType: "jpeg")!) {
            image = UIImage(data: data as Data)!
        }
        return image
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // self.clearsSelectionOnViewWillAppear = false
        loadCollectionViewData()
    }
    
    fileprivate func loadCollectionViewData() {
        let fileManager = FileManager.default
        
        /*
         BOOL isDir = NO;
         NSArray *subpaths;
         NSString *fontPath = @"/System/Library/Fonts";
         NSFileManager *fileManager = [[NSFileManager alloc] init];
         if ([fileManager fileExistsAtPath:fontPath isDirectory:&isDir] && isDir)
         subpaths = [fileManager subpathsAtPath:fontPath];
         */
        
        if fileManager.fileExists(atPath: Constants.Path.Documents) {
            print("File exists")
            if let subpaths = fileManager.subpaths(atPath: Constants.Path.Documents) {
                //                print(subpaths)
                for subpath in subpaths {
//                    print(subpath)
                    let subpathcomponentArray = subpath.components(separatedBy: ".")
                    if subpathcomponentArray.count > 1 {
                        let pathExtension = subpathcomponentArray[1]
                        if pathExtension == "jpg" {
                            let imagePath = Constants.Path.Documents.appending("/").appending(subpath)
//                            print(imagePath)
                            let imageData = NSData(contentsOfFile: imagePath)
                            if let data: NSData = imageData, let image = UIImage(data: data as Data){
                                sparrowImages.append(image)
                            }
                        }
                    } else {
                        sparrowImages.append(foldImage)
                    }
                }
            }
            /*
             do {
             let subpathsOfDirectory = try fileManager.subpathsOfDirectory(atPath: Constants.Path.Documents)
             print(subpathsOfDirectory)
             } catch {
             print("error")
             }
             */
        } else {
            print("File not found")
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
        }
     }
 
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sparrowImages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.ReuserIdentifier.uSparrowCell, for: indexPath) as? SparrowCell {
//            cell.layer.borderWidth = 1.0
//            cell.layer.borderColor = UIColor.red.cgColor
            cell.sparrowPhoto.image = sparrowImages[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
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
//fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
//fileprivate let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
fileprivate let itemsPerRow: CGFloat = 3

extension SparrowsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        print(view.frame.width)
        print(paddingSpace)
        print(availableWidth)
        print(widthPerItem)

        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
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
            self.collectionView?.reloadData()
        }
    }
}
