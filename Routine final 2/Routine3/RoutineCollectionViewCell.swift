//
//  RoutineCollectionViewCell.swift
//  Routine3
//
//  Created by user@95 on 16/11/24.
//

import UIKit

class RoutineCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var RoutineTitle: UILabel!
    
    @IBOutlet weak var RoutineimageView: UIImageView!
    
    @IBOutlet weak var RoutineSubtitle: UILabel!
    
    @IBOutlet weak var RoutineCheckbox: UIButton!
    
    @IBOutlet weak var roundedBackgroundView: UIView!
    
    var routine: Routine? // Keep a reference to the routine model

       func setup(with routine: Routine) {
           self.routine = routine
           RoutineTitle.text = routine.title
           RoutineSubtitle.text = routine.subtitle
           RoutineCheckbox.isSelected = routine.iscompleted

           updateCheckboxImage() // Update the checkbox image

           RoutineCheckbox.tintColor = .white
           RoutineimageView.image = routine.image // Set the image for the image view

           // Apply rounded top corners to the image view
           roundTopCorners(view: RoutineimageView, radius: 20)

           // Configure rounded bottom corners for the background view
           roundedBackgroundView.backgroundColor = .white // Ensure it's set to white
           roundBottomCorners(view: roundedBackgroundView, radius: 20)

           // Add target for the checkbox button
           RoutineCheckbox.addTarget(self, action: #selector(didTapCheckbox), for: .touchUpInside)
       }

       @objc private func didTapCheckbox() {
           // Toggle the isSelected state
           RoutineCheckbox.isSelected.toggle()
           
           // Update the model's iscompleted property
           routine?.iscompleted = RoutineCheckbox.isSelected

           // Update the checkbox image
           updateCheckboxImage()
       }

       private func updateCheckboxImage() {
           let imageName = RoutineCheckbox.isSelected ? "checkmark" : "unchecked"
           RoutineCheckbox.setImage(UIImage(named: imageName), for: .normal)
       }

       private func roundTopCorners(view: UIView, radius: CGFloat) {
           DispatchQueue.main.async {
               let path = UIBezierPath(roundedRect: view.bounds,
                                       byRoundingCorners: [.topLeft, .topRight],
                                       cornerRadii: CGSize(width: radius, height: radius))
               let mask = CAShapeLayer()
               mask.path = path.cgPath
               view.layer.mask = mask
               view.clipsToBounds = true
           }
       }

       private func roundBottomCorners(view: UIView, radius: CGFloat) {
           DispatchQueue.main.async {
               let path = UIBezierPath(roundedRect: view.bounds,
                                       byRoundingCorners: [.bottomLeft, .bottomRight],
                                       cornerRadii: CGSize(width: radius, height: radius))
               let mask = CAShapeLayer()
               mask.path = path.cgPath
               view.layer.mask = mask
               view.clipsToBounds = true
           }
       }

       override func layoutSubviews() {
           super.layoutSubviews()
           // Ensure the rounded corners are applied after layout
           roundTopCorners(view: RoutineimageView, radius: 20)
           roundBottomCorners(view: roundedBackgroundView, radius: 20)
       }
   }
