//
//  completeRoutine2TableViewCell.swift
//  Routine3
//
//  Created by user@95 on 18/11/24.
//

import UIKit

class completeRoutine2TableViewCell: UITableViewCell {
    @IBOutlet weak var producttypeCR2: UILabel!
    @IBOutlet weak var imageviewCR2: UIImageView!
    @IBOutlet weak var productdescriptionCR2: UILabel!
    
    @IBOutlet weak var timeCR2: UILabel!
    func configure(with log: CompleteLogCR2) {
        producttypeCR2.text = log.producttypeCR2
        timeCR2.text = log.timeCR2
        productdescriptionCR2.text = log.productdescriptionCR2
        imageviewCR2.image = log.productsimageCR2
        
        
        // Set the checkbox image based on the checklistCheckedCR2 value
        
    }
}
