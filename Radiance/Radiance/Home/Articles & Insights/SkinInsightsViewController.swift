//
//  SkinInsightsViewController.swift
//  Home
//
//  Created by admin12 on 13/11/24.
//

import UIKit

class SkinInsightsViewController: UIViewController {

   
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UITextView!
    
    @IBOutlet weak var learnMoreButton: UIButton!
    
    var imageName: String?
    var titleImage: String?
    var descriptionText: String?
    var urlString: String?
    
    
    
    func configure(with insight: SkinInsight) {
        imageView.image = UIImage(named: insight.imageName)
        titleLabel.text = titleImage
        
        
        overlayView.layer.cornerRadius = 12 // Adjust the value as needed
        overlayView.layer.masksToBounds = true
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = UIImage(named: imageName ?? "")
        titleLabel.text = titleImage ?? ""
        overlayView.layer.cornerRadius = 12 // Adjust the value as needed
        overlayView.layer.masksToBounds = true
        descriptionLabel.text = descriptionText
        
        
    }
    

    @IBAction func learnMoreButtonTapped(_ sender: UIButton) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
                    print("Invalid URL")
                    return
                }
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
