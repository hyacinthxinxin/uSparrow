//
//  SparrowCell.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowCell: UICollectionViewCell {
    
    @IBOutlet weak var sparrowPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1.0
        layer.borderColor = themeColor.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
}
