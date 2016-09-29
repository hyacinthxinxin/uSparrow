//
//  ViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

protocol UploadViewControllerDelegate: class {
    func uploadViewController(_ controller: UploadViewController, didCancelNeedUpdate isNeedUpdate: Bool)
}

class UploadViewController: UIViewController {
    private var webServer: GCDWebUploader?
    weak var delegate: UploadViewControllerDelegate?
    var isNeedUpdate = false
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.webServer = GCDWebUploader(uploadDirectory: Constants.Path.Documents)
        if let webServer = self.webServer {
            webServer.delegate = self
            webServer.allowHiddenItems = true
            if webServer.start(withPort: 8888, bonjourName: "U Sparrow GCD Web Server") {
                infoLabel.text = "GCDWebServer running locally on url:port \n" + webServer.serverURL.absoluteString + String(webServer.port)
            } else {
                infoLabel.text = NSLocalizedString("GCDWebServer not running!", comment: "")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let webServer = webServer {
            webServer.stop()
        }
        webServer = nil
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
//        dismiss(animated: true, completion: nil)
        delegate?.uploadViewController(self, didCancelNeedUpdate: isNeedUpdate)
    }
}

extension UploadViewController: GCDWebUploaderDelegate {
    func webUploader(_ uploader: GCDWebUploader!, didDownloadFileAtPath path: String!) {
        print("[DOWNLOAD]" + path)
        isNeedUpdate = true
    }
    
    func webUploader(_ uploader: GCDWebUploader!, didUploadFileAtPath path: String!) {
        print("[UPLOAD]" + path)
        isNeedUpdate = true
    }
    
    func webUploader(_ uploader: GCDWebUploader!, didMoveItemFromPath fromPath: String!, toPath: String!) {
        print("[MOVE]" + fromPath + toPath)
        isNeedUpdate = true
    }
    
    func webUploader(_ uploader: GCDWebUploader!, didDeleteItemAtPath path: String!) {
        print("[DELETE]" + path)
        isNeedUpdate = true
    }
    
    func webUploader(_ uploader: GCDWebUploader!, didCreateDirectoryAtPath path: String!) {
        print("[CREATE]" + path)
        isNeedUpdate = true
    }
}
