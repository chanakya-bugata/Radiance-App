//
//  SignUpViewController.swift
//  SignUp
//
//  Created by admin2 on 18/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn  // Added GoogleSignIn import
import FirebaseCore


class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    let db = Firestore.firestore() // Firestore database instance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupJoinWithSeparator()
        
        //        passwordTextField.isSecureTextEntry = true
    }
    
    
    private func setupJoinWithSeparator() {
        
        let separatorContainer = UIView()
        separatorContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(separatorContainer)
        
        // Create the left line
        let leftLine = UIView()
        leftLine.backgroundColor = UIColor.lightGray
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        separatorContainer.addSubview(leftLine)
        
        // Create the label
        let label = UILabel()
        label.text = " or Join with"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        separatorContainer.addSubview(label)
        
        // Create the right line
        let rightLine = UIView()
        rightLine.backgroundColor = UIColor.lightGray
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        separatorContainer.addSubview(rightLine)
        
        // Add constraints for the container view
        NSLayoutConstraint.activate([
            separatorContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            separatorContainer.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 95),
            separatorContainer.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            separatorContainer.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Add constraints for the left line
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftLine.centerYAnchor.constraint(equalTo: separatorContainer.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.widthAnchor.constraint(equalTo: separatorContainer.widthAnchor, multiplier: 0.45)
        ])
        
        // Add constraints for the label
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: separatorContainer.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: separatorContainer.centerYAnchor)
        ])
        // Add constraints for the right line
        NSLayoutConstraint.activate([
            rightLine.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            rightLine.centerYAnchor.constraint(equalTo: separatorContainer.centerYAnchor),
            rightLine.heightAnchor.constraint(equalToConstant: 1),
            rightLine.widthAnchor.constraint(equalTo: separatorContainer.widthAnchor, multiplier: 0.44)
        ])
    }
    
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Sign Up Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
            showAlert(message: "Email is required.")
            return
        }
        guard let username = usernameTextField.text, !username.isEmpty else {
            showAlert(message: "Username is required.")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Password is required.")
            return
        }
        
        // Check for duplicate email or username in Firestore
        checkForDuplicateEmailOrUsername(email: email, username: username, password: password)
    }
    
    private func checkForDuplicateEmailOrUsername(email: String, username: String, password: String) {
        let usersCollection = db.collection("users")
        
        // Query to check if email or username already exists
        usersCollection
            .whereField("email", isEqualTo: email)
            .getDocuments { emailSnapshot, emailError in
                if let emailError = emailError {
                    self.showAlert(message: "Error checking email: \(emailError.localizedDescription)")
                    return
                }
                
                if let emailSnapshot = emailSnapshot, !emailSnapshot.isEmpty {
                    self.showAlert(message: "Email already exists. Please choose a different one.")
                    return
                }
                
                // Now check for duplicate username
                usersCollection
                    .whereField("username", isEqualTo: username)
                    .getDocuments { usernameSnapshot, usernameError in
                        if let usernameError = usernameError {
                            self.showAlert(message: "Error checking username: \(usernameError.localizedDescription)")
                            return
                        }
                        
                        if let usernameSnapshot = usernameSnapshot, !usernameSnapshot.isEmpty {
                            self.showAlert(message: "Username already exists. Please choose a different one.")
                            return
                        }
                        
                        // If no duplicates, proceed with Firebase Authentication
                        self.registerUser(email: email, username: username, password: password)
                    }
            }
    }
    private func registerUser(email: String, username: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.showAlert(message: "Error: \(error.localizedDescription)")
                return
            }
            self.saveUserData(email: email, username: username)
        }
    }
    
    private func saveUserData(email: String, username: String) {
        db.collection("users").document(email).setData([
            "email": email,
            "username": username,
            "skinConcerns": [],
            "skinTypes": [],
            "skinGoals": [],
            "createdAt": Timestamp(date: Date())
        ], merge: true) { error in
            if let error = error {
                self.showAlert(message: "Failed to save user data: \(error.localizedDescription)")
            } else {
                self.navigateToNextScreen()
            }
        }
    }
        
    private func navigateToNextScreen() {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "Question1ViewController") as? Question1ViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func continueGoogleButtonTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            if let error = error {
                showAlert(message: "Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            guard let user = result?.user, let idToken = user.idToken?.tokenString else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
            
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    showAlert(message: "Firebase Sign-In failed: \(error.localizedDescription)")
                    return
                }
                let email = user.profile?.email ?? ""
                let username = user.profile?.name ?? email.components(separatedBy: "@").first ?? "unknown_user"
                saveUserData(email: email, username: username)
            }
        }
    }
    
    @IBAction func continueAppleButtonTapped(_ sender: UIButton) {
    }
}
