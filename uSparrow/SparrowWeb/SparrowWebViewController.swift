//
//  SparrowWebViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/1.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowWebViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    var webUrl: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(webUrl)
//        webView.loadHTMLString("woxxxx", baseURL: webUrl)
        if let data = NSData(contentsOf: webUrl) {
            if webUrl.pathExtension == "pdf" {
            webView.load(data as Data, mimeType: "application/pdf", textEncodingName: "UTF-8", baseURL: URL(string: "http://www.baidu.com")! )
            } else if webUrl.pathExtension == "txt" {
                webView.load(data as Data, mimeType: "text/plain", textEncodingName: "UTF-16", baseURL: URL(string: "http://www.baidu.com")!)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if webView.isLoading {
            webView.stopLoading()
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
