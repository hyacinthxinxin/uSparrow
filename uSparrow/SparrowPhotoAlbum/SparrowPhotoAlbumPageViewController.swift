//
//  SparrowPhotoAlbumPageViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/8.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

enum SparrowPhotoAlbumType {
    case img
    case gif
}

class SparrowPhotoAlbumPageViewController: UIPageViewController {
    var type: SparrowPhotoAlbumType!
    var photoUrls: [URL]!
    var currentIndex: Int! {
        didSet {
            guard isViewLoaded else {
                return
            }
            setTitle()
        }
    }
    
    fileprivate func setTitle() {
        let titleString = String(currentIndex + 1)
        title = "("+titleString+"/"+String(photoUrls.count)+")"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitle()
        
        dataSource = self
        delegate = self
        if let viewController = viewPhotoDetailController(with: type, index: currentIndex ?? 0) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
        }
    }
    
    func viewPhotoDetailController(with photoAlbumType: SparrowPhotoAlbumType, index: Int) -> UIViewController? {
        if photoAlbumType == .img {
            if let storyboard = storyboard, let page = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardId.imgVC) as? SparrowImageViewController {
                page.photoIndex = index
                page.photoUrl = photoUrls[index]
                return page
            }
            
        } else if photoAlbumType == .gif {
            if let storyboard = storyboard, let page = storyboard.instantiateViewController(withIdentifier: Constants.StoryboardId.gifVC) as? SparrowGifViewController {
                page.photoIndex = index
                page.photoUrl = photoUrls[index]
                return page
            }
        }
        return nil
    }
}

//MARK: implementation of UIPageViewControllerDataSource
extension SparrowPhotoAlbumPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if type == .img {
            if let viewController = viewController as? SparrowImageViewController {
                var index = viewController.photoIndex
                guard index != NSNotFound && index != 0 else { return nil }
                index = index! - 1
                return viewPhotoDetailController(with: .img, index: index!)
            }
            
        } else if type == .gif{
            if let viewController = viewController as? SparrowGifViewController {
                var index = viewController.photoIndex
                guard index != NSNotFound && index != 0 else { return nil }
                index = index! - 1
                return viewPhotoDetailController(with: .gif, index: index!)
            }
            
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if type == .img {
            if let viewController = viewController as? SparrowImageViewController {
                var index = viewController.photoIndex
                guard index != NSNotFound else { return nil }
                index = index! + 1
                guard index != photoUrls.count else {return nil}
                return viewPhotoDetailController(with: .img, index: index!)
            }
            
        } else if type == .gif {
            if let viewController = viewController as? SparrowGifViewController {
                var index = viewController.photoIndex
                guard index != NSNotFound else { return nil }
                index = index! + 1
                guard index != photoUrls.count else {return nil}
                return viewPhotoDetailController(with: .gif, index: index!)
            }
            
        }
        return nil
    }
    
}

extension SparrowPhotoAlbumPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if type == .img {
            let pageContentViewController = pageViewController.viewControllers![0] as! SparrowImageViewController
            currentIndex = pageContentViewController.photoIndex
        } else if type == .gif {
            let pageContentViewController = pageViewController.viewControllers![0] as! SparrowGifViewController
            currentIndex = pageContentViewController.photoIndex
        }
    }
    
}
