//
//  CategoryCell.swift
//  Home
//
//  Created by admin12 on 09/11/24.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func configure(with category: Category) {
        imageView.image = UIImage(named: category.imageName)
        titleLabel.text = category.title
        makeImageViewCircular(imageView)
        
        }
    func makeImageViewCircular(_ imageView: UIImageView) {
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true
    }

}
