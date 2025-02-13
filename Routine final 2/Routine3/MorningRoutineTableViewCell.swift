//
//  MorningRoutineTableViewCell.swift
//  Routine3
//
//  Created by user@95 on 17/11/24.
//

import UIKit

class MorningRoutineTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var productimage: UIImageView!
    @IBOutlet weak var productdetail: UILabel!
    @IBOutlet weak var producttype: UILabel!
    @IBOutlet weak var btnCheckmark: UIButton!
    @IBOutlet weak var time: UILabel!
    
    override func awakeFromNib() {
          super.awakeFromNib()
          contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
      }
      
      func configure(with log: MorningLog) {
          self.producttype.text = log.producttype
          self.productdetail.text = log.productdescription
          self.productimage.image = log.productsimage
          self.time.text = log.time
          let checkmarkImageName = log.MrnglogChecklist ? "checkmark" : "unchecked"
          self.btnCheckmark.setImage(UIImage(named: checkmarkImageName), for: .normal)
      }
  }
