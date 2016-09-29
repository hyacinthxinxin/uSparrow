//
//  SparrowModel.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/29.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import Foundation
import UIKit

class SparrowFold: NSObject {
    var name: String = ""
    var documentsUrl: URL?
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
