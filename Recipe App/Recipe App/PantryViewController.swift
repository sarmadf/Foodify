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
    var tapGesture = UITapGestureRecognizer()
    var selectEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.IngredientsList.dataSource = self
        self.IngredientsList.delegate = self
        self.IngredientsList.allowsMultipleSelection = true
        self.IngredientsList.allowsMultipleSelectionDuringEditing = true
        
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.IngredientsList.backgroundView = UIView()
        self.IngredientsList.backgroundView?.addGestureRecognizer(tapGesture)
        
        self.Ingredients = Storage.ingredients
    }
    
    @IBAction func CancelButtonPressed(_ sender: Any) {
        self.TopNavBar.isHidden = false
        self.TopNavBar2.isHidden = true
        self.OptionsToolbar.isHidden = true
        self.BottomNavbar.isHidden = false
        self.selectEnabled = false
        self.deselectCells()
        self.unhideCellButtons()
    }
    
    @IBAction func SelectButtonPressed(_ sender: Any) {
        self.TopNavBar.isHidden = true
        self.TopNavBar2.isHidden = false
        self.OptionsToolbar.isHidden = false
        self.BottomNavbar.isHidden = true
        self.selectEnabled = true
        self.hideCellButtons()
        
    }
    
    @IBAction func AddButtonPressed(_ sender: Any) {
        self.deselectCells()
        performSegue(withIdentifier: "pantryingredientsadd", sender: self)
    }
    
    
    @IBAction func DeleteButtonPressed(_ sender: Any) {
        var toDelete:[String] = []
        let selectedItems = self.IngredientsList.indexPathsForSelectedRows ?? []
        for index in selectedItems {
            let temp = self.IngredientsList.cellForRow(at: index) as? PantryViewCell
            toDelete.append(temp?.NameField.text ?? "")
        }
        self.CancelButtonPressed(UIButton())
        removeIngredients(array: toDelete)
        self.Ingredients = Storage.ingredients
        self.IngredientsList.reloadData()
    }
    
    @IBAction func SearchButtonPressed(_ sender: Any) {
        for index in self.IngredientsList.indexPathsForSelectedRows ?? [] {
            print(index)
            // TODO: Funnel selected ingredients into API
        }
        self.deselectCells()
        performSegue(withIdentifier: "recipeSearch", sender: self)
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
        
        self.dismissKeyboard()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath){
       if(self.selectEnabled == true){
           let cell = self.IngredientsList.visibleCells[indexPath.row] as? PantryViewCell ?? PantryViewCell()
           
        tableView.cellForRow(at: indexPath)?.contentView.backgroundColor = UIColor.white
        cell.NameField?.backgroundColor = UIColor.white
       }
    }
    
    // Other
    @objc func dismissKeyboard(){
        let cells = self.IngredientsList.visibleCells.map{ $0 as? PantryViewCell ?? PantryViewCell() }
        _ = cells.map { (cell) in
            cell.NameField.resignFirstResponder()
            cell.NameField.isUserInteractionEnabled = false
        }
    }
    
    func deselectCells() {
        let selectedItems = self.IngredientsList.indexPathsForSelectedRows ?? []
        for index in selectedItems {
            self.IngredientsList.deselectRow(at: index, animated:false)

            let cell = self.IngredientsList.cellForRow(at: index) as? PantryViewCell
            cell?.contentView.backgroundColor = UIColor.white
            cell?.NameField?.backgroundColor = UIColor.white
        }
    }
    
    func hideCellButtons() {
        _ = self.IngredientsList.visibleCells.map{
            let curCell = $0 as? PantryViewCell ?? PantryViewCell()
            curCell.RenameButton.isHidden = true
        }
    }
    
    func unhideCellButtons() {
        _ = self.IngredientsList.visibleCells.map{
            let curCell = $0 as? PantryViewCell ?? PantryViewCell()
            curCell.RenameButton.isHidden = false
        }
    }
    
    @IBAction func toolBarSearchButtonDown(_ sender: Any) {
        self.deselectCells()
        performSegue(withIdentifier: "homeScreen", sender: self)
    }
    
    @IBAction func toolBarProfileButtonDown(_ sender: Any) {
        self.deselectCells()
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func toolBarPantryButtonDown(_ sender: Any) {
        // Do nothing, already in target VC
    }
}

class PantryViewCell: UITableViewCell {
    @IBOutlet weak var NameField: UITextView!
    @IBOutlet weak var RenameButton: UIButton!
    
    var tapGesture = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.RenameButton.setImage(UIImage(named:"Rename"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func rename(_ sender: Any) {
        self.NameField.isUserInteractionEnabled = true
        self.NameField.becomeFirstResponder()
         
    }
    
    @objc func dismissKeyboard() {
        self.NameField.resignFirstResponder()
        self.NameField.isUserInteractionEnabled = false
    }
}


