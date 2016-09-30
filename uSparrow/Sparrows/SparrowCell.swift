//
//  SparrowCell.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowCell: UICollectionViewCell {
    var sparrow: Sparrow? {
        didSet {
            print(sparrow)
        }
    }
    
    @IBOutlet weak var sparrowPhoto: UIImageView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    
    var sparrowImageModel: SparrowImageModel? {
        didSet {
            if let image = sparrowImageModel?.sparrowImage{
                self.sparrowPhoto.image = image
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
        sparrowPhoto.image = nil
    }
}
