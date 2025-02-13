//
//  completeRoutine1TableViewCell.swift
//  Routine3
//
//  Created by user@95 on 18/11/24.
//

import UIKit

class completeRoutine1TableViewCell: UITableViewCell {
    @IBOutlet weak var producttypeCR: UILabel!
    
    @IBOutlet weak var productdescriptionCR: UILabel!
    @IBOutlet weak var imageviewCR: UIImageView!
    @IBOutlet weak var timeCR: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Function to configure the cell with data
    func configureCell(with log: CompleteLogCR) {
        // Set the product type, description, time, and image
        producttypeCR.text = log.producttypeCR
        productdescriptionCR.text = log.productdescriptionCR
        timeCR.text = log.timeCR
        imageviewCR.image = log.productsimageCR
        
        // Set the checkbox image based on the checked state
        
    }
}
