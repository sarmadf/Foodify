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
    @IBOutlet weak var TopNavBar: UINavigationBar!
    @IBOutlet weak var TopNavBar2: UINavigationBar!
    
    @IBOutlet weak var OptionsToolbar: UIToolbar!
    @IBOutlet var BottomNavbar: UIToolbar!
    @IBOutlet weak var SelectButton: UIBarButtonItem!
    @IBOutlet weak var SearchButton: UIBarButtonItem!
    @IBOutlet weak var DeleteButton: UIBarButtonItem!
    var Ingredients: [String] = []
    var selectedIngredients: [String] = []
    var tapGesture = UITapGestureRecognizer()
    var selectEnabled = false
    
    var apiModel:ApiModel = ApiModel.init(apiKey: "f46182926fb74d808fafa4299a536a6d")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.IngredientsList.dataSource = self
        self.IngredientsList.delegate = self
        self.IngredientsList.allowsMultipleSelection = true
        self.IngredientsList.allowsMultipleSelectionDuringEditing = true
        
        self.IngredientsList.backgroundView = UIView()
        self.IngredientsList.backgroundView?.addGestureRecognizer(tapGesture)
        
        self.Ingredients = Storage.ingredients
    }
    
    // The Cancel button reverts the navigation bars to their normal states.
    @IBAction func CancelButtonPressed(_ sender: Any) {
        self.TopNavBar.isHidden = false
        self.TopNavBar2.isHidden = true
        self.OptionsToolbar.isHidden = true
        self.BottomNavbar.isHidden = false
        self.selectEnabled = false
        self.deselectCells()
    }
    
    // The Select Button pulls up two hidden Navigation bars used for selecting ingredients.
    @IBAction func SelectButtonPressed(_ sender: Any) {
        self.TopNavBar.isHidden = true
        self.TopNavBar2.isHidden = false
        self.OptionsToolbar.isHidden = false
        self.BottomNavbar.isHidden = true
        self.selectEnabled = true
        
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        self.deselectCells()
        performSegue(withIdentifier: "pantryingredientsadd", sender: self)
    }
    
    
    @IBAction func DeleteButtonPressed(_ sender: Any) {
        var toDelete:[String] = []
        let selectedItems = self.IngredientsList.indexPathsForSelectedRows ?? []
        
        // Get selected cells in the Ingredients List Table
        for index in selectedItems {
            let temp = self.IngredientsList.cellForRow(at: index) as? PantryViewCell
            toDelete.append(temp?.NameField.text ?? "")
        }
        
        // The app deletes the selected ingredients from our Storage class.
        self.CancelButtonPressed(UIButton())
        removeIngredients(array: toDelete)
        self.Ingredients = Storage.ingredients
        self.IngredientsList.reloadData()
    }
    
    @IBAction func SearchButtonPressed(_ sender: Any) {
        for index in self.IngredientsList.indexPathsForSelectedRows ?? [] {
            if let curCell = self.IngredientsList.cellForRow(at: index) as? PantryViewCell {
                self.selectedIngredients.append(curCell.NameField.text)
            }
        }
        performSegue(withIdentifier: "recipeSearch", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue is to the RecipesViewController, initialize its ingredients list and pass on the api model.
        if let vc = segue.destination as? RecipesViewController
        {
            var urlCompatibleSelectedIngredients:[String] = []
            for ingredient in selectedIngredients{
                urlCompatibleSelectedIngredients.append(ingredient.replacingOccurrences(of: " ", with: "%20"))
            }
            vc.ingredientsList = urlCompatibleSelectedIngredients.joined(separator: ",")
            vc.apiModel = self.apiModel
            vc.seguedFrom = .pantry
        }
    }
    
    // Implementing Table View Protocol
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PantryViewCell = tableView.dequeueReusableCell(withIdentifier: "PantryViewCell") as? PantryViewCell ?? PantryViewCell()
        cell.NameField?.text = self.Ingredients[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if(self.selectEnabled == true){
            let cell = self.IngredientsList.visibleCells[indexPath.row] as? PantryViewCell ?? PantryViewCell()
            
            tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor(red: 200/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)
            cell.NameField?.backgroundColor = UIColor(red: 200/255.0, green: 224/255.0, blue: 224/255.0, alpha: 1.0)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
       if(self.selectEnabled == true){
           let cell = self.IngredientsList.visibleCells[indexPath.row] as? PantryViewCell ?? PantryViewCell()
           
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.white
        cell.NameField?.backgroundColor = UIColor.white
       }
    }
    
    // Goes through all selected cells and deselects them, ensuring that cells don't stay
    // selected in and out of other views. 
    func deselectCells() {
        let selectedItems = self.IngredientsList.indexPathsForSelectedRows ?? []
        for index in selectedItems {
            self.IngredientsList.deselectRow(at: index, animated:false)

            let cell = self.IngredientsList.cellForRow(at: index) as? PantryViewCell
            cell?.contentView.backgroundColor = UIColor.white
            cell?.NameField?.backgroundColor = UIColor.white
        }
    }
        
    @IBAction func toolBarHomeButtonDown(_ sender: Any) {
        self.deselectCells()
        performSegue(withIdentifier: "homeScreen", sender: self)
    }
    
    @IBAction func toolBarPantryButtonDown(_ sender: Any) {
        // Do nothing, already in target VC
    }
}

class PantryViewCell: UITableViewCell {
    @IBOutlet weak var NameField: UITextView!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


