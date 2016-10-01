//
//  SparrowTextDetailViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/1.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowTextDetailViewController: UIViewController {
    var textUrl: URL!
    var text: String?
    
    @IBOutlet weak var textView: UITextView!
    
    deinit {
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: self.textUrl)
                let string = String(data: data, encoding: String.Encoding.utf8)
                DispatchQueue.main.async {
                    self.display(text: text)
                }
            } catch let err {
                print(err.localizedDescription)
            }
        }*/
        if let text = self.text {
            display(text: text)
        }
    }

    fileprivate func display(text: String) {
        textView.text = text
        textView.scrollRangeToVisible(NSRange(location:0, length:0))
    }

}
