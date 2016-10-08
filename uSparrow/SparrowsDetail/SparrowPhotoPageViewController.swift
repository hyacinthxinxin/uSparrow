//
//  SparrowPhotoPageViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/8.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

protocol SparrowPhotoPageViewControllerDelegate {
    func photoPageViewController(_ photo: SparrowPhotoPageViewController, didSelect index: Int)
}

class SparrowPhotoPageViewController: UIPageViewController {
    var photoPageViewControllerDelegate: SparrowPhotoPageViewControllerDelegate?
    
    var sparrowThumbnails: [UIImage]!
    var photoUrls: [URL]!
    var startingIndex = 0 {
        didSet {
            if isViewLoaded {
                if let viewController = newPhotoViewController(startingIndex) {
                    let viewControllers = [viewController]
                    setViewControllers(viewControllers, direction: .forward, animated: false, completion: nil)
                }
            }
        }
    }

    fileprivate func newPhotoViewController(_ index: Int) -> SparrowPhotoViewController? {
        if let page = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardId.photoVC) as? SparrowPhotoViewController {
            page.photoIndex = index
            page.photoUrl = photoUrls[index]
            return page
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        if let viewController = newPhotoViewController(startingIndex) {
            let viewControllers = [viewController]
            setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        }
    }
}

extension SparrowPhotoPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? SparrowPhotoViewController {
            var index = viewController.photoIndex
            guard index != NSNotFound && index != 0 else { return nil }
            photoPageViewControllerDelegate?.photoPageViewController(self, didSelect: index!)
            index = index! - 1
            return newPhotoViewController(index!)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let viewController = viewController as? SparrowPhotoViewController {
            var index = viewController.photoIndex
            guard index != NSNotFound else { return nil }
            photoPageViewControllerDelegate?.photoPageViewController(self, didSelect: index!)
            index = index! + 1
            guard index != sparrowThumbnails.count else {return nil}
            return newPhotoViewController(index!)
        }
        return nil
    }
}

extension SparrowPhotoPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
}
