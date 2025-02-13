//
//  HomeViewController.swift
//  Home
//
//  Created by admin12 on 07/11/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var skinInsightsCollectionView: UICollectionView!
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBarButton() // Ensure the button updates when the view appears
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //        view.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1)
        
        categoriesCollectionView.dataSource = self
        skinInsightsCollectionView.dataSource = self
        articlesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        skinInsightsCollectionView.delegate = self
        articlesCollectionView.delegate = self
        
        setupNavigationBarButton() // Setup the sign-in/streak button
        
        // Listen for authentication changes
        Auth.auth().addStateDidChangeListener { [weak self] _, _ in
            self?.setupNavigationBarButton()
        }
    }
    
    @IBAction func captureButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let captureVC = storyboard.instantiateViewController(withIdentifier: "CaptureViewController") as? CaptureViewController {
            navigationController?.pushViewController(captureVC, animated: true)
        }
    }
    
    func setupNavigationBarButton() {
        if let user = Auth.auth().currentUser {
            // If user is signed in, fetch streak count
            fetchUserStreak(userId: user.uid) { streakCount in
                let streakButton = UIBarButtonItem(
                    title: "Streaks 🔥 \(streakCount)",
                    style: .plain,
                    target: self,
                    action: #selector(self.streakButtonTapped)
                )
                self.navigationItem.rightBarButtonItem = streakButton
            }
        } else {
            // If user is not signed in, show Sign In button
            let signInButton = UIBarButtonItem(
                title: "Sign In",
                style: .plain,
                target: self,
                action: #selector(self.signInButtonTapped)
            )
            self.navigationItem.rightBarButtonItem = signInButton
        }
    }
    
    @objc func signInButtonTapped() {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func streakButtonTapped() {
        guard let user = Auth.auth().currentUser else { return }
        
        fetchUserStreak(userId: user.uid) { streakCount in
            let alert = UIAlertController(title: "Streaks 🔥: \(streakCount)", message: nil, preferredStyle: .actionSheet)
            
            let logoutAction = UIAlertAction(title: "Logout", style: .destructive) { _ in
                self.logoutUser()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(logoutAction)
            alert.addAction(cancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    func logoutUser() {
        do {
            try Auth.auth().signOut()
            setupNavigationBarButton() // Update UI after logout
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }

    
    func fetchUserStreak(userId: String, completion: @escaping (Int) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { snapshot, error in
            if let data = snapshot?.data(), let streak = data["streak"] as? Int {
                completion(streak)
            } else {
                completion(0) // Default streak if not found
            }
        }
    }
}


extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoriesCollectionView {
            return categories.count
        } else if collectionView == skinInsightsCollectionView {
            return skinInsights.count
        } else {
            return articles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoriesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
            cell.configure(with: categories[indexPath.item])
            return cell
        } else if collectionView == skinInsightsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SkinInsightCell", for: indexPath) as! SkinInsightCell
            cell.configure(with: skinInsights[indexPath.item])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
            cell.configure(with: articles[indexPath.item])
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoriesCollectionView {
            // Navigate to a new screen for the selected category
            let selectedCategory = categories[indexPath.item]
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let recommendedVC = storyboard.instantiateViewController(withIdentifier: "CategoryCellViewController") as? CategoryCellViewController {
                recommendedVC.categoryTitle = selectedCategory.title
                navigationController?.pushViewController(recommendedVC, animated: true)
            }
        } else if collectionView == skinInsightsCollectionView {
            // Navigate to a new screen for the selected skin insight
            let selectedInsight = skinInsights[indexPath.item]
            
            // Instantiate the DetailViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "SkinInsightsViewController") as? SkinInsightsViewController {
                // Pass data to the detail view controller
                detailVC.imageName = selectedInsight.imageName
                detailVC.descriptionText = "\(selectedInsight.description)."
                detailVC.titleImage = selectedInsight.title
                detailVC.urlString = selectedInsight.url
                detailVC.urlString = selectedInsight.url
                
                // Navigate to the detail view controller
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
            
        } else if collectionView == articlesCollectionView {
            
            // Navigate to a new screen for the selected article
            
            let selectedarticle = articles[indexPath.item]
            
            // Instantiate the DetailViewController
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let detailVC = storyboard.instantiateViewController(withIdentifier: "SkinInsightsViewController") as? SkinInsightsViewController {
                // Pass data to the detail view controller
                detailVC.imageName = selectedarticle.imageName
                detailVC.descriptionText = "\(selectedarticle.description)."
                detailVC.titleImage = selectedarticle.title
                detailVC.urlString = selectedarticle.url
                
                // Navigate to the detail view controller
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
    }
    
    
}

