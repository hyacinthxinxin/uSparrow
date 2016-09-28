//
//  ViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    private var webServer: GCDWebUploader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first {
            webServer = GCDWebUploader(uploadDirectory: documentsPath)
            if let webServer = webServer {
                webServer.delegate = self
                webServer.allowHiddenItems = true
                if webServer.start() {
                    print(webServer.port)
                } else {
                    print("webServer not running")
                }

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
}

extension ViewController: GCDWebUploaderDelegate {
    func webUploader(_ uploader: GCDWebUploader!, didDownloadFileAtPath path: String!) {
        print("[DOWNLOAD]" + path)
    }
    func webUploader(_ uploader: GCDWebUploader!, didUploadFileAtPath path: String!) {
        print("[UPLOAD]" + path)
    }
    
    func webUploader(_ uploader: GCDWebUploader!, didMoveItemFromPath fromPath: String!, toPath: String!) {
        print("[MOVE]" + fromPath + toPath)
    }
    
    func webUploader(_ uploader: GCDWebUploader!, didDeleteItemAtPath path: String!) {
        print("[DELETE]" + path)
    }
    
    func webUploader(_ uploader: GCDWebUploader!, didCreateDirectoryAtPath path: String!) {
        print("[CREATE]" + path)
    }
}
