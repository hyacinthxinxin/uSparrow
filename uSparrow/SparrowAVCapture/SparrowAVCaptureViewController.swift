//
//  SparrowAVCaptureViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/1.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import AVFoundation

class SparrowAVCaptureViewController: UIViewController {
    let captureSession = AVCaptureSession()
    
    
    var captureDevice : AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureSession.sessionPreset = AVCaptureSessionPresetLow
        
        if let devices = AVCaptureDevice.devices() {
            print(devices)
            for device in devices {
                if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                    if((device as AnyObject).position == AVCaptureDevicePosition.back) {
                        captureDevice = device as? AVCaptureDevice
                    }
                }
            }
        }
        beginSession()
    }

    func beginSession() {
        configureDevice()
        if let captureDevice = self.captureDevice {
            do {
                let input = try AVCaptureDeviceInput(device: captureDevice)
                captureSession.addInput(input)
                
                if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                    view.layer.addSublayer(previewLayer)
                    previewLayer.frame = self.view.layer.frame
                    captureSession.startRunning()
                }
                
            } catch {
                
            }
        }
    }
    
    func configureDevice() {
        if let captureDevice = self.captureDevice {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.focusMode = .locked
                captureDevice.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    func focusTo(value : Float) {
        if let captureDevice = captureDevice {
            do {
                try captureDevice.lockForConfiguration()
                captureDevice.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    //
                })
                captureDevice.unlockForConfiguration()
            } catch {
                
            }
        }
    }
    
    let screenWidth = UIScreen.main.bounds.size.width
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPercent = touch.location(in: self.view).x / screenWidth
            focusTo(value: Float(touchPercent))
        }
        super.touchesBegan(touches, with: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchPercent = touch.location(in: self.view).x / screenWidth
            focusTo(value: Float(touchPercent))
        }
        super.touchesMoved(touches, with: event)
    }

}
