//
//  IngredientTableViewCell.swift
//  Home
//
//  Created by admin12 on 18/11/24.
//

import UIKit

class ProductIngredientTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var riskLevelLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        riskLevelLabel.layer.cornerRadius = riskLevelLabel.frame.size.width / 2
        riskLevelLabel.layer.masksToBounds = true
        riskLevelLabel.textColor = .white
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func configure(with ingredient: Ingredient) {
        nameLabel.text = ingredient.name
        riskLevelLabel.text = "\(ingredient.riskLevel)"
        
        // Set background color based on risk level
        switch ingredient.riskLevel {
        case 0...3:
            riskLevelLabel.backgroundColor = UIColor.systemGreen
        case 4...7:
            riskLevelLabel.backgroundColor = UIColor.systemOrange
        case 8...10:
            riskLevelLabel.backgroundColor = UIColor.systemRed
        default:
            riskLevelLabel.backgroundColor = UIColor.gray // Default color
        }
    }
}
