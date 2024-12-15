//
//  LoginViewController.swift
//  SignUp
//
//  Created by admin2 on 18/11/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore



class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var appleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupJoinWithSeparator()
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
        label.text = " or Join with "
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
            separatorContainer.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 125),
            separatorContainer.widthAnchor.constraint(equalTo: passwordTextField.widthAnchor),
            separatorContainer.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // Add constraints for the left line
        NSLayoutConstraint.activate([
            leftLine.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            leftLine.centerYAnchor.constraint(equalTo: separatorContainer.centerYAnchor),
            leftLine.heightAnchor.constraint(equalToConstant: 1),
            leftLine.widthAnchor.constraint(equalTo: separatorContainer.widthAnchor, multiplier: 0.44)
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
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        if validateFields() {
            let email = emailTextField.text!
            let password = passwordTextField.text!
            
            // Authenticate user with Firebase
            signInUser(email: email, password: password)
        }
    }
    private func signInUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                self?.showAlert(message: "Login failed: \(error.localizedDescription)")
                return
            }
            
            // Login successful: Navigate to MainTabBarController
            self?.navigateToMainTabBarController()
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    
    private func validateFields() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please fill in all fields.")
            return false
        }
        if !isValidEmail(email) {
            showAlert(message: "Please enter a valid email address.")
            return false
        }
        return true
    }

    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func navigateToMainTabBarController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? UITabBarController {
            guard let window = UIApplication.shared.windows.first else { return }
            
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              animations: {
                window.rootViewController = tabBarController
            },
                              completion: nil)
        }
    }

    
    @IBAction func forgotPasswordTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Reset Password",
                                      message: "Enter your email to receive a password reset link.",
                                      preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        alert.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self] _ in
            if let email = alert.textFields?.first?.text, !email.isEmpty {
                self?.sendPasswordReset(to: email)
            } else {
                self?.showAlert(message: "Please enter a valid email.")
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func sendPasswordReset(to email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                self.showAlert(message: "Failed to send reset link: \(error.localizedDescription)")
            } else {
                self.showAlert(message: "A password reset link has been sent to \(email). Please check your email inbox.")
            }
        }
    }

    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @IBAction func continueGoogleButtonTapped(_ sender: UIButton) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { result, error in
            if let error = error {
                self.showAlert(message: "Google Sign-In failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user, let idToken = user.idToken else { return }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: user.accessToken.tokenString)
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    self.showAlert(message: "Firebase Sign-In with Google failed: \(error.localizedDescription)")
                } else {
                    self.navigateToMainTabBarController()
                }
            }
        }
    }
    
    @IBAction func continueAppleButtonTapped(_ sender: UIButton) {
        
    }
}
