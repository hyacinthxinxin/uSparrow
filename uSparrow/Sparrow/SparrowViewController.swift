//
//  SparrowViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/29.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowViewController: UIViewController {
    var sparrowPhoto: UIImage?
    @IBOutlet weak var sparrowImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let image = sparrowPhoto {
            sparrowImageView.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
