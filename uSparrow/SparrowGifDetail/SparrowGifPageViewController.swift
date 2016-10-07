//
//  SparrowGifPageViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowGifPageViewController: UIPageViewController {
    var startingIndex = 0
    var gifUrls: [URL]!
    var gifViewControllers: [SparrowGifViewController]!
    
    deinit {
        print(#function)
    }

    private func newGifViewController(url: URL) -> SparrowGifViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: Constants.StoryboardId.gifVC) as! SparrowGifViewController
    }
    
    private func stylePageControl() {
        let pageControl = UIPageControl.appearance(whenContainedInInstancesOf: [type(of: self)])
        pageControl.currentPageIndicatorTintColor = Constants.SparrowTheme.selectedColor
        pageControl.pageIndicatorTintColor = Constants.SparrowTheme.textColor
        pageControl.backgroundColor = Constants.SparrowTheme.backgroundColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stylePageControl()
        gifViewControllers = gifUrls.map {
            let gifViewController = newGifViewController(url: $0)
            gifViewController.gifUrl = $0
            return gifViewController
        }
        
        dataSource = self
        setViewControllers([gifViewControllers[startingIndex]], direction: .forward, animated: true, completion: nil)
    }
    
}

extension SparrowGifPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = gifViewControllers.index(of: viewController as! SparrowGifViewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1

        guard previousIndex >= 0 else {
            return nil
        }
        
        guard gifViewControllers.count > previousIndex else {
            return nil
        }
        
        return gifViewControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = gifViewControllers.index(of: viewController as! SparrowGifViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        let gifViewControllersCount = gifViewControllers.count
        
        guard gifViewControllersCount != nextIndex else {
            return nil
        }
        
        guard gifViewControllersCount > nextIndex else {
            return nil
        }
        
        return gifViewControllers[nextIndex]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return gifUrls.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first, let firstViewControllerIndex = gifViewControllers.index(of: firstViewController as! SparrowGifViewController) else {
                return 0
        }
        return firstViewControllerIndex
    }
}
