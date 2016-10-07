//
//  SparrowGifViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowGifViewController: UIViewController {
    var gifUrl: URL?
    
    @IBOutlet weak var gifImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.SparrowTheme.backgroundColor
        if let url = gifUrl {
            gifImageView.loadGif(url: url)
        }
    }
}
