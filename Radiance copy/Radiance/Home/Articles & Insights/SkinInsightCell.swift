//
//  SkinInsightCell.swift
//  Home
//
//  Created by admin12 on 09/11/24.
//

import UIKit

class SkinInsightCell: UICollectionViewCell {
    
    @IBOutlet var overlayView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    

        func configure(with insight: SkinInsight) {
            imageView.image = UIImage(named: insight.imageName)
            titleLabel.text = insight.title
            
            overlayView.layer.cornerRadius = 12 // Adjust the value as needed
            overlayView.layer.masksToBounds = true
        }
    }

