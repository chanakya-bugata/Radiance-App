//
//  Question4ViewController.swift
//  QuizRadiance
//
//  Created by admin2 on 18/11/24.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class Question4ViewController: UIViewController {
    
    let skinGoal = ["Hydration", "Acne Free", "Anti-Aging", "Sun Protection", "Even Skin Tone", "Face Glow"]
    
    
    let customPink = UIColor(red: 242/255, green: 141/255, blue: 134/255, alpha: 1.0)
    
    var selectedSkinGoal: [String] = []
    
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
        for (index, goal) in skinGoal.enumerated() {
            
            if index % buttonsPerRow == 0 {
                currentHorizontalStackView = UIStackView()
                currentHorizontalStackView?.axis = .horizontal
                currentHorizontalStackView?.alignment = .fill
                currentHorizontalStackView?.distribution = .fillEqually
                currentHorizontalStackView?.spacing = 10
                
                // Add the new horizontal stack to the vertical stack
                if let horizontalStack = currentHorizontalStackView {
                    verticalStackView.addArrangedSubview(horizontalStack)
                }
            }
            
            
            let button = UIButton(type: .system)
            button.setTitle(goal, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.layer.borderWidth = 1.5
            button.layer.borderColor = customPink.cgColor
            button.layer.cornerRadius = 15
            button.backgroundColor = .white
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            button.heightAnchor.constraint(equalToConstant: 60).isActive = true
            button.addTarget(self, action: #selector(goalButtonTapped(_:)), for: .touchUpInside)
            currentHorizontalStackView?.addArrangedSubview(button)
        }
    }
    
    @objc func goalButtonTapped(_ sender: UIButton) {
        if sender.backgroundColor == customPink {
            sender.backgroundColor = .white
            sender.setTitleColor(.black, for: .normal)
            if let title = sender.titleLabel?.text, let index = selectedSkinGoal.firstIndex(of: title) {
                selectedSkinGoal.remove(at: index)
            }
        } else {
            sender.backgroundColor = customPink
            sender.setTitleColor(.white, for: .normal)
            if let title = sender.titleLabel?.text, !selectedSkinGoal.contains(title) {
                selectedSkinGoal.append(title)
            }
        }
    }
    
    @IBAction func finishButtonTapped(_ sender: Any) {
        // Validate selection
        if selectedSkinGoal.isEmpty {
            showAlert(message: "Please select at least one skin goal.")
            return
        }
        
        // Save the selected skin goals to the User singleton
        User.shared.skinGoals = selectedSkinGoal
        
        // Save the user data to Firebase
        saveSkinGoalsToFirebase()
        
        // Show success alert
        let alert = UIAlertController(title: "Success", message: "You have successfully completed the quiz!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.navigateToNextScreen()
        })
        present(alert, animated: true, completion: nil)
    }
    
    func saveSkinGoalsToFirebase() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        let userRef = Firestore.firestore().collection("users").document(userID)
        
        let data: [String: Any] = [
            "skinGoals": User.shared.skinGoals
        ]
        
        userRef.setData(data, merge: true) { error in
            if let error = error {
                print("Error saving skin goals: \(error.localizedDescription)")
                self.showAlert(message: "Failed to save your skin goals. Please try again.")
            } else {
                print("Skin goals successfully saved to Firebase.")
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Invalid Input", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
        }
    }
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = tabBarController
                window.makeKeyAndVisible()
            }
        }
    }
}

