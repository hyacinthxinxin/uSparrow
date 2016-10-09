//
//  SparrowAuthViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/3.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

func delay(seconds: Double, completion:@escaping ()->()) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

class SparrowAuthViewController: UIViewController {
    @IBOutlet weak var gesturePasswordView: SparrowGesturePasswordView!
    
    @IBOutlet weak var statusLabel: UILabel!
    var uSparrowSecret: String?
    
    deinit {
        print(String(describing: self) + String(#function))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gesturePasswordView.gestureTentacleView.delegate = self
        setupGesturePasswordView()
    }
    
    func setupGesturePasswordView() {
        if let uSparrowSecret = UserDefaults.standard.object(forKey: Constants.UserDefaultKey.uSparrowSecret) as? String {
            forgetPasswordItem.isEnabled = true
            gesturePasswordView.gestureTentacleView.style = 1
            statusLabel.text = "请输入手势密码"
            self.uSparrowSecret = uSparrowSecret
        } else {
            statusLabel.text = "请设置手势密码"
            gesturePasswordView.gestureTentacleView.style = 2
            forgetPasswordItem.isEnabled = false
            self.uSparrowSecret = nil
        }
    }
    
    @IBOutlet weak var forgetPasswordItem: UIBarButtonItem!
    @IBAction func forgetPassword (_ sender: AnyObject) {
        performSegue(withIdentifier: Constants.SegueIdentifier.ShowForget, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SegueIdentifier.ShowForget {
            if let forget = segue.destination as? SparrowForgetViewController {
                forget.delegate = self
            }
        }
    }
    
    fileprivate func authSuccess() {
        delay(seconds: 0.4, completion: { [weak weakSelf = self] in
            weakSelf?.dismiss(animated: false, completion: nil)
        })
    }
}

extension SparrowAuthViewController: SparrowGestureTentacleViewDelegate {
    func tentacleView(gestureTouchBegin tentacleView: SparrowGestureTentacleView) {
        
    }
    
    func tentacleView(_ tentacleView: SparrowGestureTentacleView, verification result: String) -> Bool {
        if let uSparrowSecret = self.uSparrowSecret {
            if uSparrowSecret == result {
                //验证成功
                statusLabel.text = "手势密码验证成功"
                self.authSuccess()
                return true
            } else {
                //验证失败
                statusLabel.text = "手势密码验证失败"
                delay(seconds: 0.4, completion: {
                    tentacleView.enterArgin()
                })
                return false
            }
        }
        return false
    }
    
    func tentacleView(_ tentacleView: SparrowGestureTentacleView, resetPassword result: String) -> Bool {
        if let uSparrowSecret = self.uSparrowSecret {
            if uSparrowSecret == result {
                //两次密码一致
                //保存密码到default
                statusLabel.text = "手势密码设置成功"
                UserDefaults.standard.set(uSparrowSecret, forKey: Constants.UserDefaultKey.uSparrowSecret)
                guard UserDefaults.standard.synchronize() else {
                    return false
                }
                self.authSuccess()
                return true
            } else {
                //两次密码不一致
                statusLabel.text = "两次手势密码不一致"
                tentacleView.enterArgin()
                return false
            }
        } else {
            //第一次输入密码
            uSparrowSecret = result
            statusLabel.text = "请再次输入手势密码"
            tentacleView.enterArgin()
            return true
        }
    }
    
}

extension SparrowAuthViewController: SparrowForgetViewControllerDelegate {
    func forgetViewController(_ forgetViewController: SparrowForgetViewController, resetPassword success: Bool) {
        guard success else {
            return
        }
        setupGesturePasswordView()
    }
    
}
