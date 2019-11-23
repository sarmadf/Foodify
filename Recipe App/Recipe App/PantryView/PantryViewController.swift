//
//  Pantry.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

/* TODO:
        - Add Delete Button to PantryViewCell?
        - Give PantryViewCells background images (like a star icon, trash icon, etc)
 */

import UIKit

class PantryViewController: UIViewController, UITableViewDelegate,  UITableViewDataSource {
    @IBOutlet weak var IngredientsList: UITableView!
    var Ingredients: [String] = []
    var tapGesture = UITapGestureRecognizer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.IngredientsList.dataSource = self
        self.IngredientsList.delegate = self
        self.IngredientsList.allowsMultipleSelection = true
        self.IngredientsList.allowsMultipleSelectionDuringEditing = true
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.IngredientsList.backgroundView = UIView()
        self.IngredientsList.backgroundView?.addGestureRecognizer(tapGesture)
        
        
        // TODO: Fill in Ingredients array properly
        self.Ingredients = ["Carrot", "Onion", "Salmon", "Apple Cider Vinegar", "Bob's Red Mill Flour Organic Amazing the Best Flour of all Time"]
    }
    
    @IBAction func SearchButtonPressed(_ sender: Any) {
        for index in self.IngredientsList.indexPathsForSelectedRows ?? [] {
            print(index)
            // TODO: Funnel selected ingredients into API
        }
        
        performSegue(withIdentifier: "recipeSearch", sender: self)
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        // TODO: Pull up IngredientsSearch view
    }
    
    // Implementing Table View Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PantryViewCell = tableView.dequeueReusableCell(withIdentifier: "PantryViewCell") as? PantryViewCell ?? PantryViewCell()
        cell.NameField?.text = self.Ingredients[indexPath.row]
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.lightGray
        let cell = self.IngredientsList.visibleCells[indexPath.row] as? PantryViewCell ?? PantryViewCell()
        cell.NameField?.backgroundColor = UIColor.lightGray
        
        self.dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.white
        let cell = self.IngredientsList.visibleCells[indexPath.row] as? PantryViewCell ?? PantryViewCell()
        cell.NameField?.backgroundColor = UIColor.white
    }
    
    
    // Other
    @objc func dismissKeyboard(){
        let cells = self.IngredientsList.visibleCells.map{ $0 as? PantryViewCell ?? PantryViewCell() }
        _ = cells.map { (cell) in
            cell.NameField.resignFirstResponder()
            cell.NameField.isUserInteractionEnabled = false
        }
    }
    
    
    @IBAction func toolBarSearchButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "homeScreen", sender: self)
    }
    
    @IBAction func toolBarProfileButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func toolBarPantryButtonDown(_ sender: Any) {
        // Do nothing, already in target VC
    }
}

