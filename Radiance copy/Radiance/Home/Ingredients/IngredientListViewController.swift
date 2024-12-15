//
//  IngredientListViewController.swift
//  Home
//
//  Created by admin12 on 18/11/24.
//

import UIKit

class IngredientListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    
    var ingredients: [Ingredient] = [] // List of ingredients passed from the previous view controller
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the title of the navigation bar
        self.navigationItem.title = "Product Ingredients"
        tableView.dataSource = self
        tableView.delegate = self

       
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as! ProductIngredientTableViewCell
        let ingredient = ingredients[indexPath.row]
        cell.configure(with: ingredient)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle navigation to a detailed page for the selected ingredient
        let selectedIngredient = ingredients[indexPath.row]
        // Assume you have a detailed view controller for ingredients, you can navigate to it
        // Example: performSegue(withIdentifier: "showIngredientDetail", sender: selectedIngredient)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}
