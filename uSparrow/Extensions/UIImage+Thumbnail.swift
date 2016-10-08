//
//  UIImage+Thumbnail.swift
//  uSparrow
//
//  Created by 新 范 on 2016/10/8.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

extension UIImage {
    func thumbnailOfSize(_ size: CGFloat) -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: size, height: size))
        let rect = CGRect(x: 0.0, y: 0.0, width: size, height: size)
        UIGraphicsBeginImageContext(rect.size)
        draw(in: rect)
        let thumbnail = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext()
        return thumbnail!
    }
}
