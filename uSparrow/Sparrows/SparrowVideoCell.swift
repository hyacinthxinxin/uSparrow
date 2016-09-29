//
//  SparrowVideoCell.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/30.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import AVFoundation

class SparrowVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var sparrowVideoImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    var sparrowVideoModel : SparrowVideoModel? {
        didSet {
            if let url = sparrowVideoModel?.documentsUrl {
                DispatchQueue.global().async {
                    let asset = AVURLAsset(url: url)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    do {
                        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                        DispatchQueue.main.async {
                            self.sparrowVideoImageView.image = UIImage(cgImage: cgImage)
                            self.timeLabel.text = asset.duration.durationString
                        }
                    } catch let error as NSError {
                        print("Error generating thumbnail: \(error)")
                    }
                }
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
}
