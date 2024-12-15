//
//  ProductDetailViewController.swift
//  Home
//
//  Created by admin12 on 18/11/24.
//

import UIKit

class ProductDetailViewController: UIViewController {
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var shopNowButton: UIButton!
    @IBOutlet weak var ingredientListButton: UIButton!
    @IBOutlet weak var ingredientsCircleView: UIView!
    @IBOutlet weak var benefitsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var starRatingView: UIView!
    @IBOutlet weak var reviewsBasedOnLabel: UILabel!
    
    @IBOutlet weak var circleOverlay: UIView!
    
    
    @IBOutlet weak var noOfIngredients: UILabel!
    
    var product: Product?
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = product {
            updateUI(with: product)
        }
    }
    
    @IBAction func shopNowButtonTapped(_ sender: UIButton) {
        guard let product = product,
                let url = URL(string: product.url) else {
            print("Invalid URL")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    
    
    @IBAction func showIngredientList(_ sender: UIButton) {
        guard let ingredients = product?.ingredients else { return }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let ingredientsVC = storyboard.instantiateViewController(withIdentifier: "IngredientListViewController") as? IngredientListViewController {
            ingredientsVC.ingredients = ingredients
            navigationController?.pushViewController(ingredientsVC, animated: true)
        }else {
            print("Error: Unable to instantiate IngredientListViewController")
        }
        
    }
    
    
    func updateUI(with product: Product) {
        productImageView.image = UIImage(named: product.imageName)
        productTitleLabel.text = product.name
        productTypeLabel.text = product.type
        
        benefitsLabel.text = product.benefits
        reviewsBasedOnLabel.text = "Based on \(product.numberOfReviews) reviews"
        ratingLabel.text = "\(product.rating)"
        
        // Update Star rating
        updateStarRating(rating: product.rating)
        
        // Update ingredients circle color based on average risk level
        updateIngredientsCircle(ingredients: product.ingredients)
    }
    
    func updateIngredientsCircle(ingredients: [Ingredient]) {
        let averageRiskLevel = ingredients.map { $0.riskLevel }.reduce(0, +) / ingredients.count
        
        noOfIngredients.text = "\(ingredients.count)"
            
        // Set the circle color based on average risk level
        switch averageRiskLevel {
        case 0..<4:
            ingredientsCircleView.backgroundColor = .systemGreen
        case 4..<8:
            ingredientsCircleView.backgroundColor = .systemOrange
        case 8..<11:
            ingredientsCircleView.backgroundColor = .systemRed
        default:
            ingredientsCircleView.backgroundColor = .systemGray
        }
        
        ingredientsCircleView.layer.cornerRadius = ingredientsCircleView.frame.height / 2
        ingredientsCircleView.layer.masksToBounds = true
        circleOverlay.layer.cornerRadius = circleOverlay.frame.height / 2
        circleOverlay.layer.masksToBounds = true
            
//        // Update the text showing the number of ingredients
//        ingredientListButton.setTitle("\(ingredients.count) Ingredients", for: .normal)
    }
    
    func updateStarRating(rating: Float) {
        // Determine the number of filled stars
        let filledStars = Int(rating)
        let hasHalfStar = rating - Float(filledStars) >= 0.5
        
        // Create the star rating view based on filled stars
        var starViews = [UIView]()
        
        for i in 0..<5 {
        let star = UIImageView(image: UIImage(systemName: i < filledStars ? "star.fill" : (i == filledStars && hasHalfStar ? "star.leadinghalf.fill" : "star")))
        star.tintColor = .systemYellow
        starViews.append(star)
    }
                
    // Add the star views to the starRatingView
        starRatingView.subviews.forEach { $0.removeFromSuperview() } // Clear existing stars
        starViews.forEach { starRatingView.addSubview($0) }
                
    // Layout the stars (e.g., horizontally spaced)
        var xOffset: CGFloat = 0
        for star in starViews {
            star.frame = CGRect(x: 10 + xOffset, y: 0, width: 25, height: 25)
            xOffset += 25 // Adjust spacing
        }
        
    }

}
