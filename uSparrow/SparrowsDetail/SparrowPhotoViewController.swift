//
//  SparrowPhotoViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/8.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowPhotoViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    open var photoIndex: Int!
    open var photoUrl: URL! {
        didSet {
            if isViewLoaded {
                setupImageView()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.SparrowTheme.backgroundColor
        setupImageView()
    }
    
    fileprivate func setupImageView() {
        do {
            let data = try Data(contentsOf: photoUrl)
            imageView.image = UIImage(data: data)
            
        } catch {
            
        }
    }
}

extension SparrowPhotoViewController: UIScrollViewDelegate {
    //    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    //        return imageView
    //    }
    //
    //    func scrollViewDidZoom(_ scrollView: UIScrollView) {
    //        updateConstraintsForSize(size: view.bounds.size)
    //    }
}
