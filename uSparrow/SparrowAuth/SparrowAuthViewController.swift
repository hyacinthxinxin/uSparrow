//
//  SparrowAuthViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/3.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowAuthViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func enterPassword(_ sender: AnyObject) {
        authSuccess()
    }
    
    func authSuccess() {
        dismiss(animated: false, completion: nil)
    }

}
