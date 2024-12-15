//
//  Question2ViewController.swift
//  QuizRadiance
//
//  Created by admin2 on 18/11/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth


class Question2ViewController: UIViewController {
    
    let db = Firestore.firestore() // Reference to Firestore
    
    let skinConcerns = ["Acne", "Dryness", "Oily Skin", "Aging", "Sensitive", "Sun Damage"]
    
    // Define custom pink color
    let customPink = UIColor(red: 242/255, green: 141/255, blue: 134/255, alpha: 1.0)
    
    var selectedConcerns: [String] = [] // Stores selected concerns
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Create and configure the heading label
        let headingLabel = UILabel()
        // Add the heading label to the main view
        view.addSubview(headingLabel)
        
        // Create and configure the vertical stack view
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 15 // Increase spacing between rows
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the vertical stack view to the main view
        view.addSubview(verticalStackView)
        
        // Set constraints for the heading label
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Set constraints for the vertical stack view to place it 30 points below the heading label
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 215),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Define the number of buttons per row
        let buttonsPerRow = 2
        var currentHorizontalStackView: UIStackView?
        
        // Loop through the skin concerns and create buttons
        for (index, concern) in skinConcerns.enumerated() {
            
            // Every time we reach the start of a new row, create a new horizontal stack view
            if index % buttonsPerRow == 0 {
                currentHorizontalStackView = UIStackView()
                currentHorizontalStackView?.axis = .horizontal
                currentHorizontalStackView?.alignment = .fill
                currentHorizontalStackView?.distribution = .fillEqually
                currentHorizontalStackView?.spacing = 10 // Space between buttons
                
                // Add the new horizontal stack to the vertical stack
                if let horizontalStack = currentHorizontalStackView {
                    verticalStackView.addArrangedSubview(horizontalStack)
                }
            }
            
            // Create the button for each skin concern
            let button = UIButton(type: .system)
            button.setTitle(concern, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 1.5 // Increased border thickness
            button.layer.borderColor = customPink.cgColor
            button.layer.cornerRadius = 15 // Increase corner radius
            button.backgroundColor = .white
            
            // Set font size to 17
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            
            // Set button height to make it bigger
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            
            // Add an action to handle button tap
            button.addTarget(self, action: #selector(concernButtonTapped(_:)), for: .touchUpInside)
            
            // Add the button to the current horizontal stack view
            currentHorizontalStackView?.addArrangedSubview(button)
        }
    }
    
    // Action for button tap to toggle selection color
    @objc func concernButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        if User.shared.skinConcerns.contains(title) {
            // Deselect the button
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = User.shared.skinConcerns.firstIndex(of: title) {
                User.shared.skinConcerns.remove(at: index)
            }
        } else {
            // Select the button
            sender.backgroundColor = customPink
            sender.setTitleColor(.white, for: .normal)
            User.shared.skinConcerns.append(title)
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if User.shared.skinConcerns.isEmpty {
            showAlert(message: "Please select at least one skin concern.")
            return
        }
        
        // Save data using User singleton
        User.shared.saveToFirebase()
        navigateToNextScreen()
    }
    
    // Function to navigate to the next screen
    func navigateToNextScreen() {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "Question3ViewController") as? Question3ViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        navigateToNextScreen()
    }
}
