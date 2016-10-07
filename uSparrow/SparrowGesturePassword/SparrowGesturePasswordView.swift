//
//  SparrowGesturePasswordView.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/7.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit


protocol GesturePasswordDelegate {
    func forget()
    func change()
}

class SparrowGesturePasswordView: UIView {
    
    var tentacleView:SparrowGestureTentacleView?
    var gesturePasswordDelegate:GesturePasswordDelegate?
    var buttonArray:[SparrowGesturePasswordButton]=[]
    var gestureTentacleView: SparrowGestureTentacleView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButtons()
    }
    
    fileprivate func setupButtons() {
        for i in 0..<9 {
            let gesturePasswordButton = SparrowGesturePasswordButton(frame: CGRect.zero)
            gesturePasswordButton.tag = i
            addSubview(gesturePasswordButton)
            buttonArray.append(gesturePasswordButton)
        }
        gestureTentacleView = SparrowGestureTentacleView(frame: CGRect.zero)
        gestureTentacleView.buttonArray = buttonArray
        addSubview(gestureTentacleView)
    }
    
    fileprivate let widthPerButton: CGFloat = 64
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for (i, btn) in buttonArray.enumerated() {
            let row = Int(i/3)
            let col = Int(i%3)
            let paddingSpace = (frame.width - 3 * widthPerButton) / (3 * 2)
            let x = CGFloat(col)*widthPerButton + paddingSpace * (CGFloat(col)*2 + 1)
            let y = CGFloat(row)*widthPerButton + paddingSpace * (CGFloat(row)*2 + 1)
            btn.frame = CGRect(x: x, y: y, width: widthPerButton, height: widthPerButton)
        }
        gestureTentacleView.frame = bounds
    }
    
    
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext();
        let rgb = CGColorSpaceCreateDeviceRGB();
        let colors:[CGFloat] = [134/255,157/255,147/255,1.0,3/255,3/255,37/255,1.0]
        let  nilUnsafePointer:UnsafePointer<CGFloat>? = nil
        let gradient = CGGradient(colorSpace: rgb, colorComponents: colors, locations: nilUnsafePointer,count: 2)
        context?.drawLinearGradient(gradient!, start: CGPoint(x: 0.0,y: 0.0),end: CGPoint(x: 0.0,y: self.frame.size.height), options: [])
    }
    
}

