//
//  SparrowCell.swift
//  uSparrow
//
//  Created by 新 范 on 2016/9/28.
//  Copyright © 2016年 TingSpectrum. All rights reserved.
//

import UIKit
import AVFoundation

class SparrowCell: UICollectionViewCell {
    @IBOutlet weak var sparrowPhoto: UIImageView!
    @IBOutlet weak var infoContainerView: UIView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var sparrow: Sparrow? {
        didSet {
            if let sparrow = self.sparrow {
                configCell(sparrow: sparrow)
            }
        }
    }
    
    private func configCell(sparrow: Sparrow) {
        if let url = sparrow.documentsUrl {
            let type: SparrowType = sparrow.type
            switch type {
            case .uSystem:
                self.sparrowPhoto.image = UIImage(named: "finder")
                
                infoContainerView.isHidden = false
                titleLabel.text = "系统文件"
                infoImageView.image = nil
                infoLabel.text = nil
            case .uFold:
                self.sparrowPhoto.image = UIImage(named: "finder")
                
                infoContainerView.isHidden = false
                titleLabel.text = url.lastPathComponent
                infoImageView.image = nil
                infoLabel.text = nil
            case .uPhoto:
                sparrowPhoto.image = sparrow.thumbnailPhoto

                infoContainerView.isHidden = true
                titleLabel.text = nil
                infoImageView.image = nil
                infoLabel.text = nil
            case .uGif:
                self.sparrowPhoto.image = UIImage.gifThumbnail(url)
                
                infoContainerView.isHidden = false
                titleLabel.text = "GIF"
                infoImageView.image = nil
                infoLabel.text = nil
            case .uVideo:
                DispatchQueue.global().async {
                    let asset = AVURLAsset(url: url)
                    let imgGenerator = AVAssetImageGenerator(asset: asset)
                    imgGenerator.appliesPreferredTrackTransform = true
                    do {
                        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(0, 1), actualTime: nil)
                        DispatchQueue.main.async {
                            self.sparrowPhoto.image = UIImage(cgImage: cgImage)
                            
                            self.infoContainerView.isHidden = false
                            self.titleLabel.text = nil
                            self.infoImageView.image = UIImage(named: "videocam")
                            self.infoLabel.text = asset.duration.durationString
                        }
                    } catch let error as NSError {
                        print("Error generating thumbnail: \(error)")
                    }
                }
            case .uDoc:
                self.sparrowPhoto.image = UIImage(named: "finder")
                
                infoContainerView.isHidden = false
                titleLabel.text = url.lastPathComponent
                infoImageView.image = nil
                infoLabel.text = nil
                
            case .uOthers:
                self.sparrowPhoto.image = UIImage(named: "finder")
                
                infoContainerView.isHidden = false
                titleLabel.text = url.lastPathComponent
                infoImageView.image = nil
                infoLabel.text = nil
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
        
        infoContainerView.isHidden = true
        titleLabel.text = nil
        infoImageView.image = nil
        infoLabel.text = nil
    }
}
