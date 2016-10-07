//
//  SparrowGestureTentacleView.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/7.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

protocol SparrowGestureTentacleViewDelegate {
    func tentacleView(gestureTouchBegin tentacleView: SparrowGestureTentacleView)
    func tentacleView(_ tentacleView: SparrowGestureTentacleView, verification result:String) -> Bool
    func tentacleView(_ tentacleView: SparrowGestureTentacleView, resetPassword result:String) -> Bool
}

class SparrowGestureTentacleView: UIView {
    
    var buttonArray:[SparrowGesturePasswordButton]=[]
    var touchesArray:[Dictionary<String,Float>]=[]
    var touchedArray:[String] = []
    
    var lineStartPoint:CGPoint?
    var lineEndPoint:CGPoint?
    
    var delegate:SparrowGestureTentacleViewDelegate?
    
    var style:Int?
    
    var success:Bool = false
    var drawed:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.isUserInteractionEnabled = true
        success = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        var touchPoint:CGPoint
        let touch:UITouch? = touches.first!
        
        touchesArray.removeAll()
        touchedArray.removeAll()
        
        delegate?.tentacleView(gestureTouchBegin: self)
        success = true
        drawed = false
        
        if(touch != nil){
            
            
            touchPoint = touch!.location(in: self)
            
            
            for i in 0..<buttonArray.count {
                
                let buttonTemp = buttonArray[i]
                buttonTemp.success = true
                buttonTemp.selected = false
                
                if(buttonTemp.frame.contains(touchPoint)){
                    let frameTemp = buttonTemp.frame
                    let point = CGPoint(x: frameTemp.origin.x+frameTemp.size.width/2,y: frameTemp.origin.y+frameTemp.size.height/2)
                    
                    var dict:Dictionary<String,Float> = [:]
                    dict["x"] = Float(point.x)
                    dict["y"] = Float(point.y)
                    //dict["num"] = Float(i)
                    
                    touchesArray.append(dict)
                    lineStartPoint = touchPoint
                    
                }
                
                buttonTemp.setNeedsDisplay()
            }
            
            self.setNeedsDisplay()
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        var touchPoint:CGPoint
        let touch:UITouch? = touches.first!
        
        
        if(touch != nil){
            
            
            touchPoint = touch!.location(in: self)
            for i in 0 ..< buttonArray.count {
                
                let buttonTemp = buttonArray[i]
                
                if(buttonTemp.frame.contains(touchPoint)){
                    
                    let tps = touchedArray.filter{el in el=="num\(i)"}
                    
                    if(tps.count > 0){
                        
                        lineEndPoint = touchPoint
                        self.setNeedsDisplay()
                        return
                    }
                    touchedArray.append("num\(i)")
                    buttonTemp.selected = true
                    
                    buttonTemp.setNeedsDisplay()
                    
                    let frameTemp = buttonTemp.frame
                    let point = CGPoint(x: frameTemp.origin.x+frameTemp.size.width/2,y: frameTemp.origin.y+frameTemp.size.height/2)
                    var dict:Dictionary<String,Float> = [:]
                    dict["x"] = Float(point.x)
                    dict["y"] = Float(point.y)
                    dict["num"] = Float(i)
                    touchesArray.append(dict)
                    break;
                    
                }
            }
            
            lineEndPoint = touchPoint
            self.setNeedsDisplay()
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        var resultString:String = ""
        for p in touchesArray {
            if(p["num"] == nil){
                continue
            }
            let num=Int(p["num"]!)
            resultString = resultString + "\(num)"
        }
        drawed = true
        if(style==1){
            if let success = delegate?.tentacleView(self, verification: resultString) {
                self.success = success
            }
        } else {
            if let success = delegate?.tentacleView(self, resetPassword: resultString) {
                self.success = success
            }
        }
        
        for i in 0..<touchesArray.count {
            
            if(touchesArray[i]["num"] == nil){
                continue
            }
            
            let selection:Int = Int(touchesArray[i]["num"]!)
            let buttonTemp = buttonArray[selection]
            buttonTemp.success = success
            buttonTemp.setNeedsDisplay()
        }
        self.setNeedsDisplay()
        
    }
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        if(touchesArray.count<=0){
            return;
        }
        
        for i in 0..<touchesArray.count {
            
            let context:CGContext = UIGraphicsGetCurrentContext()!
            
            if(touchesArray[i]["num"] == nil){
                touchesArray.remove(at: i)
                //i = i-1;
                continue
            }
            
            if (success) {
                context.setStrokeColor(red: 2/255, green: 174/255, blue: 240/255, alpha: 0.7);//线条颜色
            }
            else {
                context.setStrokeColor(red: 208/255, green: 36/255, blue: 36/255, alpha: 0.7);//红色
            }
            
            context.setLineWidth(5)
            
            context.move(to: CGPoint(x: CGFloat(touchesArray[i]["x"]!), y: CGFloat(touchesArray[i]["y"]!)))
            
            if(i<touchesArray.count-1){
                
                context.addLine(to: CGPoint(x: CGFloat(touchesArray[i+1]["x"]!), y: CGFloat(touchesArray[i+1]["y"]!)))
            }
            else{
                
                if(success && drawed != true){
                    context.addLine(to: CGPoint(x: lineEndPoint!.x, y: lineEndPoint!.y));
                }
            }
            context.strokePath()
            
        }
    }

    func enterArgin() {
        touchesArray.removeAll()
        touchedArray.removeAll()
        for i in 0..<buttonArray.count {
            let buttonTemp = buttonArray[i]
            buttonTemp.success = true
            buttonTemp.selected = false
            buttonTemp.setNeedsDisplay()
        }
        self.setNeedsDisplay()
    }
    
}
