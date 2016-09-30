//
//  Constants.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit

enum SparrowType {
    case uSystem
    case uPhoto
    case uFold
    case uVideo
    case uGif
    case uText
    case uOthers
}

enum CompassPoint {
    case north
    case south
    case east
    case west
}

struct Constants {
    struct DefaultsKey {
        static let doveSessionKey = "session"
        static let doveTokenKey = "token"
        static let rongCloudTokenKey = "rongCloudTokenKey"
    }
    
    struct NetworkAddress {
        static let DevelopAddress: String = "http://192.168.100.9:9000/"
        static let ProductAddress: String = "http://www.tingspectrum.com:9000/"
    }
    
    struct SegueIdentifier {
        static let ShowUpload = "ShowUpload"
        static let ShowSparrowFold = "ShowSparrowFold"
        static let ShowSparrow = "ShowSparrow"
        static let ShowPhotos = "ShowPhotos" //
        static let ShowGif = "ShowGif"
    }
    
    struct ReuserIdentifier {
        static let uSparrowFoldCell = "SparrowFoldCell"
        static let uSparrowCell = "SparrowCell"
        static let uSparrowGifCell = "SparrowGifCell"
        static let uSparrowVideoCell = "SparrowVideoCell"
        
        static let uSparrowsHeaderView = "SparrowsHeaderView"
        static let uSparrowsThumbnailCell = "ThumbnailCell"
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        static let Library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        static let Tmp = NSTemporaryDirectory()
    }
    
    struct Color {
        static let sparrowTintColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)
        static let sparrowBackgroundColor = UIColor.hex("#212121", alpha: 1.0)
    }
    
    struct StoryboardId {
        static let gifVC = "SparrowGifViewController"
    }
}
