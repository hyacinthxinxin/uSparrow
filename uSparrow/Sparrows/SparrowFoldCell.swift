//
//  SparrowFoldCell.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/29.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit

class SparrowFoldCell: UICollectionViewCell {
    
    @IBOutlet weak var foldImageView: UIImageView!
    @IBOutlet weak var foldNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderWidth = 1.0
        self.layer.borderColor = themeColor.cgColor
    }
    
    func configCell(with sparrowFold: SparrowFold) {
        foldNameLabel.text = sparrowFold.name
        foldImageView.image = UIImage(named: "finder")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
