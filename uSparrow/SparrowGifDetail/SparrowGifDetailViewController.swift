//
//  SparrowGifDetailViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowGifDetailViewController: UIViewController {

    var gifImage: UIImage?
    @IBOutlet weak var sparrowGifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = gifImage {
            sparrowGifImageView.image = image
        }
    }

}
