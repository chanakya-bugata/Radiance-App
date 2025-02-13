//
//  SectionHeaderView.swift
//  Routine3
//
//  Created by user@95 on 15/12/24.
//

import UIKit

class SectionHeaderView : UICollectionReusableView{

    @IBOutlet weak var titleLabel: UILabel!
    var title: String! {
        didSet {
            titleLabel.text = title
        }
    }
}
