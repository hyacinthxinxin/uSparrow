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
import ReachabilitySwift
import JDStatusBarNotification

class SparrowsViewController: UICollectionViewController {
    var documentsUrl: URL?
    var sparrows: [Sparrow]!
    lazy var imagePickerController: ImagePickerController = {
        let picker = ImagePickerController()
        picker.delegate = self
        return picker
    }()
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = Constants.SparrowTheme.backgroundColor
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
        alert.addAction(UIAlertAction(title: "相机/相册", style: .default, handler: { [weak weakSelf = self] (action: UIAlertAction!) in
            weakSelf?.present(self.imagePickerController, animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "连接局域网", style: .default, handler: { (action: UIAlertAction!) in
            if let reachability = SparrowFileManager.shared.reachability {
                guard reachability.isReachableViaWiFi else {
                    JDStatusBarNotification.show(withStatus: "请确保您的手机已经连接了无线网络", dismissAfter: 2.0, styleName: JDStatusBarStyleError);
                    return
                }
                self.performSegue(withIdentifier: Constants.SegueIdentifier.ShowUpload, sender: nil)
            }
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
            if let sparrowsVC = segue.destination as? SparrowsViewController, let indexPath = collectionView?.indexPathsForSelectedItems?[0] {
                sparrowsVC.documentsUrl = sparrows.filter{ $0.type.usn == indexPath.section }[indexPath.row].documentsUrl
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowPhotoAlbum {
            if let photoAlbum = segue.destination as? SparrowPhotoAlbumPageViewController, let indexPath = sender as? IndexPath {
                if indexPath.section == 2 {
                    photoAlbum.type = .img
                    photoAlbum.photoUrls = sparrows.filter{ $0.type == SparrowType.uPhoto }.map{ $0.documentsUrl! }
                } else if indexPath.section == 3 {
                    photoAlbum.type = .gif
                    photoAlbum.photoUrls = sparrows.filter{ $0.type == SparrowType.uGif }.map{ $0.documentsUrl! }
                }
                photoAlbum.currentIndex = indexPath.row
            }
        } else if segue.identifier == Constants.SegueIdentifier.ShowText {
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

fileprivate let headerHead = ["默认文件夹", "自定义文件夹", "图片", "GIF", "视频", "文本", "其他"]

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
            headerView.sparrowsHeaderLabel.text = headerHead[indexPath.section] + "(" + String(sparrows.filter{ $0.type.usn == indexPath.section }.count) + ")"
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
//        case 0:
//            print("choose the system fold, should perform segue from cell")
//        case 1:
//            print("choose the custom fold, should perform segue from cell")
        case 2:
            performSegue(withIdentifier: Constants.SegueIdentifier.ShowPhotoAlbum, sender: indexPath)
        case 3:
            performSegue(withIdentifier: Constants.SegueIdentifier.ShowPhotoAlbum, sender: indexPath)
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
            self.reloadCollectionData()
            self.collectionView?.reloadData()
        }
    }
}

extension SparrowsViewController: ImagePickerDelegate {
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
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
