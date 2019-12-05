
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class PantryIngredientsAdd: UIViewController,  UITableViewDelegate,  UITableViewDataSource, UISearchBarDelegate, SearchResultCellDelegate {
    
    @IBOutlet weak var IngredientsSearch: UISearchBar!
    @IBOutlet weak var SearchResultsTable: UITableView!
    var SearchResults: [String] = []
    var tapGesture = UITapGestureRecognizer()
    var selectedIngredients: [String] = []
    
    var apiModel:ApiModel = ApiModel.init(apiKey: "09a25a561f214661b1d16e44550f4aeb")
    
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
        if selected {
            selectedIngredients.append(ingredient)
        }
        else {
            if let index = selectedIngredients.firstIndex(of: ingredient){
                selectedIngredients.remove(at: index)
            }
        }
    }
    
    // SearchBar Protocol Implmentation
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchString = IngredientsSearch.text{
            let ingredient = searchString.replacingOccurrences(of: " ", with: "%20")
            apiModel.autocompleteIngredients(ingredient: ingredient, completion: {
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
        IngredientsSearch.text = ""
        self.IngredientsSearch.resignFirstResponder()
    }
    
    // NavBar buttons
    @IBAction func addButtonDown(_ sender: Any) {
        print("Add Button Pressed")
        print(selectedIngredients)
        if selectedIngredients.count > 0{
            addIngredients(array: selectedIngredients)
            performSegue(withIdentifier: "pantry", sender: self)
        }
    }
    
    @IBAction func backButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
    
    // Other
    @objc func dismissKeyboard(){
        self.IngredientsSearch.resignFirstResponder()
    }
}
