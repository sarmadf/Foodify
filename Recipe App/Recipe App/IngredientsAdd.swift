//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//
//  IngredientsAdd.swift
//  Recipe App
//

import UIKit

class IngredientsAdd: UIViewController,  UITableViewDelegate,  UITableViewDataSource, UISearchBarDelegate, SearchResultCellDelegate {
    @IBOutlet weak var IngredientsSearch: UISearchBar!
    @IBOutlet weak var SearchResultsTable: UITableView!
    var SearchResults: [String] = []
    var tapGesture = UITapGestureRecognizer()
    var selectedIngredients: [String] = []
    
    var initialIngredients:[String] = []
    
    var apiModel:ApiModel = ApiModel.init(apiKey: "5f3d62d4d194403ca8f289d2a39b64a6")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.SearchResultsTable.dataSource = self
        self.SearchResultsTable.delegate = self
        self.SearchResultsTable.allowsMultipleSelection = true
        self.SearchResultsTable.allowsMultipleSelectionDuringEditing = true
        
        IngredientsSearch.delegate = self
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.SearchResultsTable.backgroundView = UIView()
        self.SearchResultsTable.backgroundView?.addGestureRecognizer(tapGesture)
        
        for ingredient in initialIngredients{
            autocompleteAndUpdateUI(ingredient: ingredient)
        }
        self.IngredientsSearch.becomeFirstResponder()
        
    }
    
    // TableView Protocol Implmentation
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.SearchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SearchResultCell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as? SearchResultCell ?? SearchResultCell()
        cell.delegate = self
        cell.selectionStyle = .none
        cell.NameLabel?.text = self.SearchResults[indexPath.row]
        return cell
    }
    
    func searchResultCellClicked(ingredient: String, selected: Bool) {
        if selected{
            selectedIngredients.append(ingredient)
        }
        else{
            if let index = selectedIngredients.firstIndex(of: ingredient){
                selectedIngredients.remove(at: index)
            }
            
        }
    }
    
    // SearchBar Protocol Implmentation
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = IngredientsSearch.text{
            autocompleteAndUpdateUI(ingredient: searchString)
            
        }
        IngredientsSearch.text = ""
        self.IngredientsSearch.resignFirstResponder()
        
        
    }
    
    func autocompleteAndUpdateUI(ingredient: String){
        let urlCompatibleIngredient = ingredient.replacingOccurrences(of: " ", with: "%20")
        apiModel.autocompleteIngredients(ingredient: urlCompatibleIngredient, completion: {
            ingredientNames, errorString in
            DispatchQueue.main.async{
                if errorString == nil, let ingredientNames = ingredientNames{
                    self.SearchResults.append(contentsOf: ingredientNames)
                    self.SearchResultsTable.reloadData()
                }
                else{
                    print("Error String: \(errorString)")
                    self.IngredientsSearch.placeholder = "Please input a valid ingredient"
                }
            }
        })
    }
    
    // NavBar buttons
    @IBAction func submitButtonDown(_ sender: Any) {
        print("Submit Button Pressed")
        print(selectedIngredients)
        if selectedIngredients.count > 0{
            performSegue(withIdentifier: "recipeSearch", sender: self)
        }
    }
    
    @IBAction func cameraSearch(_ sender: Any) {
        performSegue(withIdentifier: "scamera", sender: self)
    }
    @IBAction func backButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "homeScreen", sender: self)
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
            vc.seguedFrom = .ingredientsAdd
        }
        else if let vc = segue.destination as? CameraViewController{
            vc.seguedFrom = .ingredientsAdd
        }
    }
    
    // Other
    @objc func dismissKeyboard(){
        self.IngredientsSearch.resignFirstResponder()
    }
}

class SearchResultCell: UITableViewCell {
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var checked: CheckBox!
    var delegate: SearchResultCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //    override func setSelected(_ selected: Bool, animated: Bool) {
    //        super.setSelected(selected, animated: animated)
    //    }
    
    @IBAction func checkBoxClicked(_ sender: Any) {
        print("SearchResultCell's button clicked: \(self.checked.isSelected)")
        self.checked.isSelected = !self.checked.isSelected
        delegate?.searchResultCellClicked(ingredient: self.NameLabel.text ?? "", selected: isSelected())
    }
    
    func isSelected() -> Bool{
        return self.checked.isSelected
    }
}

protocol SearchResultCellDelegate{
    func searchResultCellClicked(ingredient: String, selected: Bool)
}


