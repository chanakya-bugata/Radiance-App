//
//  Data Model.swift
//  Routine3
//
//  Created by user@95 on 16/11/24.
//

import Foundation
import UIKit

struct Routine {
    var image: UIImage?
    var title: String
    var subtitle: String
    var iscompleted: Bool
    
    init(image: UIImage?, title: String, subtitle: String, iscompleted: Bool) {
            self.image = image
            self.title = title
            self.subtitle = subtitle
            self.iscompleted = iscompleted
        }
}

var routine: [Routine] = [
    Routine(image: UIImage(named: "mrngroutine"), title: "Morning Routine", subtitle: "not done", iscompleted: false),
    Routine(image: UIImage(named: "nightroutine"), title: "Night Routine", subtitle: "not done", iscompleted: false),
    Routine(image: UIImage(named: "mrnglog"), title: "Morning log", subtitle: "not done", iscompleted: false),
    Routine(image: UIImage(named: "nightlog"), title: "Night log", subtitle: "not done", iscompleted: false)
]

import UIKit

struct MorningLog {
    var producttype: String
    var productsimage: UIImage?
    var productdescription: String
    var time: String
    var MrnglogChecklist: Bool // This should be Bool, not UIButton
}

let checklistButton = UIButton() // Initialize UIButton if needed

let morninglog: [MorningLog] = [
    MorningLog(producttype: "1. Cleanser", productsimage: UIImage(named: "cetaphil"), productdescription: "Cetaphil Gentle Skin Cleanser", time: "8:00 AM", MrnglogChecklist: false),
    MorningLog(producttype: "2. Toner", productsimage: UIImage(named: "minimalist"), productdescription: "Minimalist Glycolic Acid", time: "8:05 AM", MrnglogChecklist: false),
    MorningLog(producttype: "3. Moisturiser", productsimage: UIImage(named: "ponds"), productdescription: "Pond’s Light Moisturiser", time: "8:10 AM", MrnglogChecklist: false),
    MorningLog(producttype: "4. Sunscreen", productsimage: UIImage(named: "pondssunscreen"), productdescription: "Pond’s Serum Boost Sunscreen", time: "8:13 AM", MrnglogChecklist: false)
]


struct NightLog {
    var producttype: String
    var productsimage: UIImage?
    var productdescription: String
    var time: String
    var MrnglogChecklist: Bool // This represents the checklist state (true = checked, false = unchecked)
}
var nightlog: [NightLog] = [
       NightLog(producttype: "Cleanser", productsimage: UIImage(named: "cetaphil"), productdescription: "Cetaphil Gentle Skin Cleanser", time: "9:00 PM", MrnglogChecklist: false),
       NightLog(producttype: "Toner", productsimage: UIImage(named: "minimalist"), productdescription: "Minimalist Glycolic Acid", time: "9:05 PM", MrnglogChecklist: false),
       NightLog(producttype: "Moisturiser", productsimage: UIImage(named: "ponds"), productdescription: "Pond’s Light Moisturiser", time: "9:10 PM", MrnglogChecklist: false),
       NightLog(producttype: "Sunscreen", productsimage: UIImage(named: "pondssunscreen"), productdescription: "Pond’s Serum Boost Sunscreen", time: "9:13 PM", MrnglogChecklist: false),
       NightLog(producttype: "Add Your Pic", productsimage: UIImage(named: "add_image_icon"), productdescription: "", time: "", MrnglogChecklist: false)

   ]

struct CompleteLogCR {
    var producttypeCR: String
    var productsimageCR: UIImage?
    var productdescriptionCR: String
    var timeCR: String
    var checklistCheckedCR: Bool // Renamed for clarity
}
var completeLogCR: [CompleteLogCR] = [
    CompleteLogCR(producttypeCR: "1. Cleanser", productsimageCR: UIImage(named: "cetaphil"), productdescriptionCR: "Cetaphil Gentle Skin Cleanser", timeCR: "9:00 PM", checklistCheckedCR: false),
    CompleteLogCR(producttypeCR: "2. Toner", productsimageCR: UIImage(named: "minimalist"), productdescriptionCR: "Minimalist Glycolic Acid", timeCR: "9:05 PM", checklistCheckedCR: false),
    CompleteLogCR(producttypeCR: "3. Moisturiser", productsimageCR: UIImage(named: "ponds"), productdescriptionCR: "Pond’s Light Moisturiser", timeCR: "9:10 PM", checklistCheckedCR: false),
    CompleteLogCR(producttypeCR: "4. Sunscreen", productsimageCR: UIImage(named: "pondssunscreen"), productdescriptionCR: "Pond’s Serum Boost Sunscreen", timeCR: "9:13 PM", checklistCheckedCR: false)
   ]


struct CompleteLogCR2 {
    var producttypeCR2: String
    var productsimageCR2: UIImage?
    var productdescriptionCR2: String
    var timeCR2: String
    var checklistCheckedCR2: Bool // Renamed for clarity
}
var completeLogCR2: [CompleteLogCR2] = [
    CompleteLogCR2(producttypeCR2: "1. Cleanser", productsimageCR2: UIImage(named: "cetaphil"), productdescriptionCR2: "Cetaphil Gentle Skin Cleanser", timeCR2: "9:00 PM", checklistCheckedCR2: false),
    CompleteLogCR2(producttypeCR2: "2. Toner", productsimageCR2: UIImage(named: "minimalist"), productdescriptionCR2: "Minimalist Glycolic Acid", timeCR2: "9:05 PM", checklistCheckedCR2: false),
    CompleteLogCR2(producttypeCR2: "3. Moisturiser", productsimageCR2: UIImage(named: "ponds"), productdescriptionCR2: "Pond’s Light Moisturiser", timeCR2: "9:10 PM", checklistCheckedCR2: false),
    CompleteLogCR2(producttypeCR2: "4. Sunscreen", productsimageCR2: UIImage(named: "pondssunscreen"), productdescriptionCR2: "Pond’s Serum Boost Sunscreen", timeCR2: "9:13 PM", checklistCheckedCR2: false)
   ]
