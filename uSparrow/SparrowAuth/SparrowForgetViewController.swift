//
//  SparrowForgetViewController.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/9.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import JDStatusBarNotification

protocol SparrowForgetViewControllerDelegate: class {
    func forgetViewController(_ forgetViewController: SparrowForgetViewController, resetPassword success: Bool)

}

class SparrowForgetViewController: UIViewController {
    weak var delegate: SparrowForgetViewControllerDelegate?
    
    @IBOutlet weak var superPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(SparrowForgetViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(SparrowForgetViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//
//    func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
//        let userInfo = (notification as NSNotification).userInfo ?? [:]
//        let keyboardFrame = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
//        let adjustmentHeight = (keyboardFrame.height + 20) * (show ? 1 : -1)
//    }
//    
//    func keyboardWillShow(_ notification: Notification) {
//        adjustInsetForKeyboardShow(true, notification: notification)
//    }
//    
//    func keyboardWillHide(_ notification: Notification) {
//        adjustInsetForKeyboardShow(false, notification: notification)
//    }
    
    @IBAction func resetPassword(_ sender: AnyObject) {
        guard superPasswordTextField.text == "#0808" else {
            JDStatusBarNotification.show(withStatus: "重置密码错误", dismissAfter: 1.0, styleName: JDStatusBarStyleError);
            return
        }
        UserDefaults.standard.removeObject(forKey: Constants.UserDefaultKey.uSparrowSecret)
        delegate?.forgetViewController(self, resetPassword: true)
        if let auth = navigationController?.popViewController(animated: true) as? SparrowAuthViewController {
            print(auth)
        }
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
