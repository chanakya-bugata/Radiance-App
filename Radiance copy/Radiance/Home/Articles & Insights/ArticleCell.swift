//
//  ArticleCell.swift
//  Home
//
//  Created by admin12 on 09/11/24.
//

import UIKit

class ArticleCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var overlayView: UIView!
    
    @IBOutlet var titleLabel: UILabel!
    
    
    func configure(with article: Article) {
        imageView.image = UIImage(named: article.imageName)
        titleLabel.text = article.title
        
        overlayView.layer.cornerRadius = 12 // Adjust the value as needed
        overlayView.layer.masksToBounds = true
    }
    
}
