//
//  Constants.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation

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
        
    }
    
    struct ReuserIdentifier {
        static let uSparrowCell = "SparrowCell"
    }
    
    struct Path {
        static let Documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        static let Library = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true).first!
        static let Tmp = NSTemporaryDirectory()
    }
}
