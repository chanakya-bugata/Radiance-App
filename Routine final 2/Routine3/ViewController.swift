//
//  ViewController.swift
//  Routine3
//
//  Created by user@95 on 16/11/24.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var segmentoutlet: UISegmentedControl!
    
    @IBOutlet weak var checkinsegmentview: UIView!
    @IBOutlet weak var historysegmentview: UIView!
    // Method to round top corners
    func roundTopCorners(view: UIView, radius: CGFloat) {
            let path = UIBezierPath(roundedRect: view.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            view.layer.mask = mask
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            self.title = "Routine"
                let titleTextAttributes: [NSAttributedString.Key: Any] = [
                    .foregroundColor: UIColor(red: 62/255, green: 64/255, blue: 64/255, alpha: 1.0),
                    .font: UIFont.boldSystemFont(ofSize: 28)
                ]
                navigationController?.navigationBar.titleTextAttributes = titleTextAttributes
            let backButton = UIBarButtonItem()
                backButton.title = "Back"
                navigationItem.backBarButtonItem = backButton
            navigationItem.hidesBackButton = true

                // Bring the default view to the front
                self.view.bringSubviewToFront(checkinsegmentview)

            
            // Bring the default view to the front
            self.view.bringSubviewToFront(checkinsegmentview)
            
            // Customize segmented control
            let selectedTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: UIFont.systemFont(ofSize: 21, weight: .medium)]
            let unselectedTextAttributes: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor(red: 62/255, green: 64/255, blue: 64/255, alpha: 1.0),
                .font: UIFont.systemFont(ofSize: 21, weight: .medium)]
            
            segmentoutlet.setTitleTextAttributes(selectedTextAttributes, for: .selected)
            segmentoutlet.setTitleTextAttributes(unselectedTextAttributes, for: .normal)
            
         
        }
        
       
    @IBAction func segmentaction(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex{
        case 0:
            self.view.bringSubviewToFront(checkinsegmentview)
        case 1:
            self.view.bringSubviewToFront(historysegmentview)
        default:
            break
        }
    }
}
    
