//
//  SparrowGifCell.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowGifCell: UICollectionViewCell {
    
    @IBOutlet weak var sparrowGifThumbnailImageView: UIImageView!
    
    var sparrowGifImageModel: SparrowGifImageModel? {
        didSet {
            if let image = sparrowGifImageModel?.sparrowGifImage {
                self.sparrowGifThumbnailImageView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isSelected = false
    }
    
    override var isSelected : Bool {
        didSet {
            self.layer.borderColor = isSelected ? Constants.Color.sparrowTintColor.cgColor : UIColor.clear.cgColor
            self.layer.borderWidth = isSelected ? 2 : 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        sparrowGifThumbnailImageView.image = nil
    }
}
