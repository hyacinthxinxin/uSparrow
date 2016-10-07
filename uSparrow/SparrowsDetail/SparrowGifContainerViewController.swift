//
//  SparrowGifContainerViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowGifContainerViewController: UIViewController {
    
    @IBOutlet weak var bar: UINavigationBar!
    
    var startingIndex = 0
    var gifUrls: [URL]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.SparrowTheme.backgroundColor
        bar.barTintColor = Constants.SparrowTheme.barTintColor
        bar.tintColor = Constants.SparrowTheme.tintColor
    }
    
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.EmbedGifPage {
            if let gifPage = segue.destination as? SparrowGifPageViewController {
                gifPage.startingIndex = startingIndex
                gifPage.gifUrls = gifUrls
            }
        }
    }
    
}
