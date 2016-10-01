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
    case uFold
    case uPhoto
    case uGif
    case uVideo
    case uDoc
    case uOthers
}

extension SparrowType {
    var usn: Int {
        switch self {
        case .uSystem:
            return 0
        case .uPhoto:
            return 2
        case .uFold:
            return 1
        case .uVideo:
            return 4
        case .uGif:
            return 3
        case .uDoc:
            return 5
        case .uOthers:
            return 6
        }
    }
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
        static let ShowWeb = "ShowWeb"
        static let ShowText = "ShowText"
        
        static let EmbedGifPage = "EmbedGifPage"
    }
    
    struct ReuserIdentifier {
        static let uSparrowFoldCell = "SparrowFoldCell"
        static let uSparrowCell = "SparrowCell"
        static let uSparrowGifCell = "SparrowGifCell"
        static let uSparrowVideoCell = "SparrowVideoCell"
        
        static let uSparrowsHeaderView = "SparrowsHeaderView"
        static let uSparrowsThumbnailCell = "ThumbnailCell"
        
        static let uSparrowImageDetailHeaderView = "SparrowImageDetailHeaderView"
        static let uSparrowImageDetailFooterView = "SparrowImageDetailFooterView"
        
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        static let Library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        static let Tmp = NSTemporaryDirectory()
    }
    
    struct DocumentName {
        static let SparrowLibrarySystem = "SparrowLibrarySystem"
    }
    
    struct Color {
        static let sparrowTintColor = UIColor(red: 0.01, green: 0.41, blue: 0.22, alpha: 1.0)
        static let sparrowBackgroundColor = UIColor.hex("#212121", alpha: 1.0)
    }
    
    struct StoryboardId {
        static let gifVC = "SparrowGifViewController"
    }
}
