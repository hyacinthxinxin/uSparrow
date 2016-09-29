//
//  SparrowModel.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/29.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit

class SparrowFoldModel: NSObject {
    var name: String = ""
    var documentsUrl: URL?
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

class SparrowImageModel: NSObject {
    var documentsUrl: URL? {
        didSet {
            if let url = documentsUrl {
                if let imageData = NSData(contentsOf: url), let image = UIImage(data: imageData as Data) {
                    sparrowImage = image
                }
            }
        }
    }
    
    var sparrowImage: UIImage?
}

class SparrowGifImageModel: NSObject {
    var documentsUrl: URL? {
        didSet {
            if let url = documentsUrl {
                if let image = UIImage.gifThumbnail(url) {
                    sparrowGifImage = image
                }
//                sparrowGifImage = UIImage.gif(url: url)
            }
        }
    }
    
    var sparrowGifImage: UIImage?
}

class SparrowVideoModel: NSObject {
    var name: String = ""
    var documentsUrl: URL?
    var duration: String = ""

    convenience init(name: String) {
        self.init()
        self.name = name
    }
}

