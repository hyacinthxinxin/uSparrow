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
            DispatchQueue.global().async {
                if let url = self.documentsUrl,  let data = NSData(contentsOf: url), let image = UIImage(data: data as Data) {
                    self.thumbnailPhoto = image
                }
            }
        default:
            break
        }
    }
    
    static func getSparrowType(with pathExtension:  String) ->  SparrowType {
        switch pathExtension {
        case "jpg", "JPG", "jpeg", "JPEG", "png", "PNG":
            return .uPhoto
        case "gif", "GIF":
            return .uGif
        case "mp4", "MP4":
            return .uVideo
        case "txt", "TXT", "pdf", "PDF":
            return .uDoc
        default:
            return .uOthers
        }
    }
}

