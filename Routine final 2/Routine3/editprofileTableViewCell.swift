//
//  editprofileTableViewCell.swift
//  Routine3
//
//  Created by user@95 on 19/11/24.
//

import UIKit

class editprofileTableViewCell: UITableViewCell {
    @IBOutlet weak var editprofile: UILabel!
    
    @IBOutlet weak var editprofiletextfield: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
