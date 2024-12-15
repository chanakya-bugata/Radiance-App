//
//  Question1ViewController.swift
//  QuizRadiance
//
//  Created by admin2 on 18/11/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class Question1ViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    // Define buttons
    var maleButton: UIButton!
    var femaleButton: UIButton!
    
    // Define custom pink color
    let customPink = UIColor(red: 242/255, green: 141/255, blue: 134/255, alpha: 1.0)
    
    // Property to store user selection
    var selectedGender: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize and configure buttons
        maleButton = createButton(withTitle: "Male", icon: "")
        femaleButton = createButton(withTitle: "Female", icon: "")
        
        // Add buttons to the view and set up layout
        setupButtons()
    }
    
    // Function to create a button with a title and icon
    func createButton(withTitle title: String, icon iconName: String) -> UIButton {
        let button = UIButton(type: .system)
        
        // Set title and color
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.borderWidth = 2
        button.layer.borderColor = customPink.cgColor
        button.backgroundColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        // Set icon image for button
        if let icon = UIImage(named: iconName) {
            button.setImage(icon, for: .normal)
            button.imageView?.contentMode = .scaleAspectFit
            button.tintColor = .black
        }
        
        return button
    }
    
    func setupButtons() {
        // Layout for maleButton
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(maleButton)
        
        // Layout for femaleButton
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(femaleButton)
        
        // Adjust the positioning of buttons under the "Gender" label
        NSLayoutConstraint.activate([
            maleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            maleButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -10),
            maleButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 345), // Adjust this constant to place under "Gender"
            maleButton.heightAnchor.constraint(equalToConstant: 60),
            
            femaleButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 10),
            femaleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            femaleButton.topAnchor.constraint(equalTo: maleButton.topAnchor),
            femaleButton.heightAnchor.constraint(equalTo: maleButton.heightAnchor)
        ])
        
        // Add actions for button taps
        maleButton.addTarget(self, action: #selector(maleButtonTapped), for: .touchUpInside)
        femaleButton.addTarget(self, action: #selector(femaleButtonTapped), for: .touchUpInside)
        
        // Set initial styles
        styleButton(maleButton, isSelected: false)
        styleButton(femaleButton, isSelected: false)
    }
    
    func styleButton(_ button: UIButton, isSelected: Bool) {
        if isSelected {
            // Set custom pink color for selected button
            button.backgroundColor = customPink
            button.setTitleColor(.white, for: .normal)
        } else {
            // Set custom pink border for unselected button
            button.backgroundColor = .white
            button.setTitleColor(.black, for: .normal)
            button.layer.borderColor = customPink.cgColor
        }
    }
    
    // Button tap actions
    @objc func maleButtonTapped() {
        styleButton(maleButton, isSelected: true)
        styleButton(femaleButton, isSelected: false)
        
        // Store the selected gender
        selectedGender = "Male"
        //        saveSelection()
    }
    
    @objc func femaleButtonTapped() {
        styleButton(maleButton, isSelected: false)
        styleButton(femaleButton, isSelected: true)
        
        // Store the selected gender
        selectedGender = "Female"
        //        saveSelection()
    }
    
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let name = nameTextField.text, !name.isEmpty else {
            showAlert(message: "Name field is required.")
            return
        }
        
        guard let ageText = ageTextField.text, let age = Int(ageText), age > 0 else {
            showAlert(message: "Please enter a valid age.")
            return
        }
        
        guard let gender = selectedGender else {
            showAlert(message: "Please select a gender.")
            return
        }
        
        // Use the User singleton to save data
        User.shared.name = name
        User.shared.age = age
        User.shared.gender = gender
        
        // Save the data to Firebase using the singleton
        User.shared.saveToFirebase()
        
        // Navigate to the next screen
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "Question2ViewController") as? Question2ViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "Question2ViewController") as? Question2ViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
}
