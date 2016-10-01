//
//  SparrowModel.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/29.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit

class Sparrow: NSObject {
    
    var documentsUrl: URL?
    var type: SparrowType!
    var thumbnailPhoto: UIImage?
    var previewPhoto: UIImage?

    convenience init(documentsUrl: URL) {
        self.init()
        self.documentsUrl = documentsUrl
    }
    
    func setTumbnailPhoto() {
        switch type as SparrowType {
        case .uPhoto:
            if let url = documentsUrl,  let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
                thumbnailPhoto = image
            }
        default:
            break
        }
    }
    
    static func getSparrowType(with pathExtension:  String) ->  SparrowType {
        switch pathExtension {
        case "jpg", "jpeg", "png", "PNG":
            return SparrowType.uPhoto
        case "gif", "GIF":
            return SparrowType.uGif
        case "mp4":
            return SparrowType.uVideo
        case "txt", "TXT", "pdf", "PDF":
            return SparrowType.uDoc
        default:
            return SparrowType.uOthers
        }
    }
}

