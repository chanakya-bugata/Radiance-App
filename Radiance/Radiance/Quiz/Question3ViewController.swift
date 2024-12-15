//
//  Question3ViewController.swift
//  QuizRadiance
//
//  Created by admin2 on 18/11/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class Question3ViewController: UIViewController {
    
    // Define button titles for skin types
    let skinTypes = ["Normal", "Dry", "Oily", "Sensitive", "Combination"]
    
    // Define custom pink color
    let customPink = UIColor(red: 242/255, green: 141/255, blue: 134/255, alpha: 1.0)
    
    var selectedSkinType: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the background color of the view
        view.backgroundColor = .white
        
        // Create and configure the heading label
        let headingLabel = UILabel()
        
        // Add the heading label to the main view
        view.addSubview(headingLabel)
        
        // Create and configure the vertical stack view for buttons
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 20
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add the vertical stack view to the main view
        view.addSubview(verticalStackView)
        
        // Set constraints for the heading label
        NSLayoutConstraint.activate([
            headingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            headingLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            headingLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
        
        // Set constraints for the vertical stack view
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: headingLabel.bottomAnchor, constant: 215),
            verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
        
        // Loop through skin types to create buttons
        for skinType in skinTypes {
            // Create a button for each skin type
            let button = UIButton(type: .system)
            button.setTitle(skinType, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 1.5
            button.layer.borderColor = customPink.cgColor
            button.layer.cornerRadius = 15
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            
            // Add an action to handle button taps
            button.addTarget(self, action: #selector(skinTypeButtonTapped(_:)), for: .touchUpInside)
            
            // Set button height
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
            // Add the button to the vertical stack view
            verticalStackView.addArrangedSubview(button)
        }
    }
    
    // Action for button tap to toggle selection state
    @objc func skinTypeButtonTapped(_ sender: UIButton) {
        guard let title = sender.titleLabel?.text else { return }
        
        if sender.backgroundColor == customPink {
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let index = User.shared.skinTypes.firstIndex(of: title) {
                User.shared.skinTypes.remove(at: index)
            }
        } else {
            sender.backgroundColor = customPink
            sender.setTitleColor(.white, for: .normal)
            if !User.shared.skinTypes.contains(title) {
                User.shared.skinTypes.append(title)
            }
        }
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        if User.shared.skinTypes.isEmpty {
            showAlert(message: "Please select at least one skin type.")
            return
        }
        
        // Save selected skin types to User.shared
        User.shared.saveToFirebase()
        
        
        // Proceed to next screen (Question 4)
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "Question4ViewController") as? Question4ViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "Question4ViewController") as? Question4ViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
}
