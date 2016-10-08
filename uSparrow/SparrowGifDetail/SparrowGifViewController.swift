//
//  SparrowGifViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowGifViewController: SparrowPhotoBaseViewController {
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.SparrowTheme.backgroundColor
        gifImageView.loadGif(url: photoUrl)
    }
}
