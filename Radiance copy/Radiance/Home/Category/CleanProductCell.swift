//
//  CleanProductCell.swift
//  Home
//
//  Created by admin12 on 16/11/24.
//

import UIKit

class CleanProductCell: UICollectionViewCell {
    
    
    @IBOutlet weak var productImageView: UIImageView!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var productTypeLabel: UILabel!
    
    
    @IBOutlet weak var costLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var favoriteButton: UIButton!
    
    
    
    func configure(with product: Product) {
        productImageView.image = UIImage(named: product.imageName)
        productNameLabel.text = product.name
        productTypeLabel.text = product.type
        costLabel.text = product.cost
        // Create the star attachment and set its color to yellow
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow, renderingMode: .alwaysOriginal)
            
        // Create an attributed string with the star and product rating
        let starString = NSMutableAttributedString(attachment: starAttachment)
        let ratingString = NSAttributedString(string: " \(product.rating)")
        starString.append(ratingString)
            
        // Set the attributed text to the rating label
        ratingLabel.attributedText = starString
        
        productImageView.layer.cornerRadius = 12
        productImageView.clipsToBounds = true
        
    }
}
