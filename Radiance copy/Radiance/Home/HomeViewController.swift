//
//  HomeViewController.swift
//  Home
//
//  Created by admin12 on 07/11/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    
    @IBOutlet weak var skinInsightsCollectionView: UICollectionView!
    
   
    @IBOutlet weak var articlesCollectionView: UICollectionView!
    

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
    }
    
    @IBAction func captureButtonTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let captureVC = storyboard.instantiateViewController(withIdentifier: "CaptureViewController") as? CaptureViewController {
            navigationController?.pushViewController(captureVC, animated: true)
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if let nextVC = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
            navigationController?.pushViewController(nextVC, animated: true)
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

