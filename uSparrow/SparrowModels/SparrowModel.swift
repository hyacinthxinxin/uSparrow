//
//  SparrowModel.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/29.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit

enum SparrowType {
    case uSystem
    case uImage
    case uFold
    case uVideo
    case uGif
    case uText
    case uOthers
}

class Sparrow: NSObject {
    var documentsUrl: URL? {
        didSet {
            guard self.type == nil else {
                return
            }

            if let url = documentsUrl {
                switch url.pathExtension {
                case "jpg", "jpeg", "png", "PNG":
                    print("is image")
                case "gif", "GIF":
                    print("is gif")
                case "mp4":
                    print("is video")
                case "txt", "TXT":
                    print("is text")
                default:
                    print("is unkown type")
                }
            }
        }
    }
    
    var type: SparrowType!
    
    var thumbnail: UIImage?
    
    var info: Dictionary<String, String> = [:]
    
    convenience init(documentsUrl: URL) {
        self.init()
        self.documentsUrl = documentsUrl
    }
    
    static func getSparrowType(with pathExtension:  String) ->  SparrowType {
        switch pathExtension {
        case "jpg", "jpeg", "png", "PNG":
            print("is image")
            return SparrowType.uImage
        case "gif", "GIF":
            print("is gif")
            return SparrowType.uGif
        case "mp4":
            print("is video")
            return SparrowType.uVideo
        case "txt", "TXT":
            print("is text")
            return SparrowType.uText
        default:
            print("is unkown type")
            return SparrowType.uOthers
        }
    }
}

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

