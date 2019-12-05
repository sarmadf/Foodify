//
//  IngredientsAdd.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class IngredientsAdd: UIViewController,  UITableViewDelegate,  UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var IngredientsSearch: UISearchBar!
    @IBOutlet weak var SearchResultsTable: UITableView!
    var SearchResults: [String] = []
    var tapGesture = UITapGestureRecognizer()
    
    var apiModel:ApiModel = ApiModel.init(apiKey: "aa084a364a774dc4a25ff376f738f903")
    
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
        cell.selectionStyle = .none
        cell.NameLabel?.text = self.SearchResults[indexPath.row]
        return cell
    }
    
    // SearchBar Protocol Implmentation
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        IngredientsSearch.text = ""
        self.IngredientsSearch.resignFirstResponder()
        SearchResultsTable.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchText
        
        // TODO: Properly RETURN SEARCH RESULTS
        self.SearchResults = ["Peas", "Carrots", "Frosting", "Strawberries"]
        SearchResultsTable.reloadData()
    }
    
    // NavBar buttons
    @IBAction func submitButtonDown(_ sender: Any) {
//        var selectedIngredients: [String] = []
//        for index in self.SearchResultsTable.indexPathsForSelectedRows ?? [] {
//            let selectedCell = self.SearchResultsTable.cellForRow(at: index) as! SearchResultCell
//            selectedIngredients.append(selectedCell.NameLabel.text ?? "")
//        }
//
//        if(selectedIngredients.count > 0){
//            // TODO: send selectedIngredients to recipeSearch view.
//            print(selectedIngredients)
//            performSegue(withIdentifier: "recipeSearch", sender: self)
//        }
        performSegue(withIdentifier: "recipeSearch", sender: self)
    }
    
    @IBAction func backButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue is to the RecipesViewController, initialize its ingredients list and pass on the api model.
        if let vc = segue.destination as? RecipesViewController
        {
            vc.ingredientsList = "Milk,Butter"
            vc.apiModel = self.apiModel
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.checked.buttonClicked(self.checked)
    }
}

