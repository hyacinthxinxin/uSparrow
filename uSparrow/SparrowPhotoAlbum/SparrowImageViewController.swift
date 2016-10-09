//
//  SparrowImageViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/8.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowImageViewController: SparrowPhotoBaseViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.SparrowTheme.backgroundColor
        setupScrollView()
        setupImageView()
    }
    
    fileprivate func setupScrollView() {
        scrollView.maximumZoomScale = 2.0
        scrollView.minimumZoomScale = 1.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        scrollView.bouncesZoom = true
        scrollView.bounces = true
        scrollView.delegate = self
    }
    
    fileprivate func setupImageView() {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: self.photoUrl)
                DispatchQueue.main.async {
                    self.imageView.image = UIImage(data: data)
                }
            } catch {
                
            }
        }
    }
    
}

// MARK: UIScrollViewDelegate Protocol

extension SparrowImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = imageView.frame
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        imageView.frame = contentsFrame
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.contentSize = CGSize(width: imageView.frame.width + 1, height: imageView.frame.height + 1)
    }
}
