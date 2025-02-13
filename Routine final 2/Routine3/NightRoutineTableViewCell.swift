//
//  NightRoutineTableViewCell.swift
//  Routine3
//
//  Created by user@95 on 18/11/24.
//

import UIKit

class NightRoutineTableViewCell: UITableViewCell {
    @IBOutlet weak var producttype2: UILabel!
    @IBOutlet weak var productimage2: UIImageView!
    @IBOutlet weak var checkbox2: UIButton!

 
    @IBOutlet weak var productdetails2: UILabel!
    @IBOutlet weak var time2: UILabel!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        // Apply corner radius to cell's contentView
              contentView.layer.cornerRadius = 40
              contentView.layer.masksToBounds = true
    
          }
        }

       
