//
//  RecipeSearch.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate, UITableViewDelegate {
    
    var ingredientsList:String = ""
    var apiModel:ApiModel?
    var recipeSearchResults:[RecipeSearchResult] = []
    var recipeImages: [String: UIImage] = [:]

    @IBOutlet weak var recipesTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipesTable.delegate = self
        self.recipesTable.dataSource = self
        self.recipesTable.rowHeight = UITableView.automaticDimension
        
        if let apiModel = self.apiModel{
            apiModel.searchRecipes(ingredients: ingredientsList, completion: {
                recipeSearchResults, errorString in
                DispatchQueue.main.async {
                    if errorString == nil{
                        self.recipeSearchResults = recipeSearchResults ?? []
                        print("RecipeSearchResults = \(self.recipeSearchResults)")
                        self.recipesTable.reloadData()
                    }
                }
            })
        }
        // Do any additional setup after loading the view.
    }


    @IBAction func onBackButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "addIngredients", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSearchResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "RecipeSearchResult", for: indexPath) as! RecipeSearchResultTableViewCell
        print(recipeSearchResults[indexPath.row])
        cell.recipeNameLabel.text = recipeSearchResults[indexPath.row].title
        let missedIngredients = recipeSearchResults[indexPath.row].missedIngredients
        let missedIngredientsStr = missedIngredients.reduce("", {$0 + $1.name + "\n"})
        print("Missing Ingredients string: \(missedIngredientsStr)")
        cell.missingIngredientsLabel.text = "Missing Ingredients:\n \(missedIngredientsStr)"
        print("Missing Ingredients Label: \(cell.missingIngredientsLabel.text)")
        cell.imageView?.image = recipeImages[recipeSearchResults[indexPath.row].imageURL]
        if cell.imageView?.image == nil{
            loadImage(imageURL: recipeSearchResults[indexPath.row].imageURL, completion: {
                image, errorStr in
                if let image = image, errorStr == nil{
                    DispatchQueue.main.async {
                        let imageURL = self.recipeSearchResults[indexPath.row].imageURL
                        self.recipeImages[imageURL] = image
                        cell.imageView?.image = image
                        cell.imageView?.contentMode = .scaleAspectFit
                        cell.imageView?.clipsToBounds = true
                        cell.setNeedsLayout()
                    }
                }
                else{
                    print(errorStr ?? "")
                }
            })
        }
        return cell
    }
    
//    func loadImages(completion: @escaping () -> ()){
//        for recipeSearchResult in recipeSearchResults{
//            loadImage(imageURL: recipeSearchResult.imageURL, completion: {
//                image, errorStr in
//                if let image = image, errorStr == nil{
//                    DispatchQueue.main.async {
//                        self.recipeImages[imageURL] = image
//                    }
//                }
//                else{
//                    print(errorStr ?? "")
//                }
//            })
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
//            completion()
//        }
//    }
    
    
    
    
}

