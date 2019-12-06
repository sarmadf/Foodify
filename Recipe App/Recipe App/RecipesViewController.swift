//
//  RecipeSearch.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

    
class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var ingredientsList:String = "" //List of ingredients passed in from previous view controller. Should be a single comma-separated string of ingredients.
    var apiModel:ApiModel? //Model used to call the api
    var recipeSearchResults:[RecipeSearchResult] = [] //List of recipe search results, will be populated after api call.
    var recipeImages: [String: UIImage] = [:] //List of images, will be loaded after an api call
    var seguedFrom:SeguedFrom?

    @IBOutlet weak var recipesTable: UITableView! //Table displaying recipe search results.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recipesTable.delegate = self
        self.recipesTable.dataSource = self
        self.recipesTable.rowHeight = UITableView.automaticDimension
        
        //Search for recipes that contain the ingredients specified in ingredientsList.
        if let apiModel = self.apiModel{
            apiModel.searchRecipes(ingredients: ingredientsList, completion: {
                recipeSearchResults, errorString in
                DispatchQueue.main.async {
                    if errorString == nil{
                        //Populate recipeSearchResults. Reload the table so that it displays these results.
                        self.recipeSearchResults = recipeSearchResults ?? []
                        self.recipesTable.reloadData()
                    }
                }
            })
        }
    }


    @IBAction func onBackButtonPressed(_ sender: Any) {
        if let seguedFrom = self.seguedFrom{
            switch seguedFrom{
            case .ingredientsAdd:
                performSegue(withIdentifier: "addIngredients", sender: self)
                break
            case .pantry:
                performSegue(withIdentifier: "pantry", sender: self)
                break
            default:
                performSegue(withIdentifier: "pantry", sender: self)
                break
            }
        }
        else {
            performSegue(withIdentifier: "pantry", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeSearchResults.count
    
}
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140.0;//Choose your custom row height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "RecipeSearchResult", for: indexPath) as! RecipeSearchResultTableViewCell
        //Populate the name and missing ingredients labels of the cell's content view.
        cell.recipeNameLabel.text = recipeSearchResults[indexPath.row].title
        let missedIngredients = recipeSearchResults[indexPath.row].missedIngredients
        let missedIngredientsStr = missedIngredients.reduce("", {$0 + $1.name + "\n"})
        cell.missingIngredientsLabel.text = "Missing Ingredients:\n \(missedIngredientsStr)"
        
        //If the recipe image is not already cached, load it.
        cell.recipeImage.image = recipeImages[recipeSearchResults[indexPath.row].imageURL]
        if cell.recipeImage.image == nil{
            loadImage(imageURL: recipeSearchResults[indexPath.row].imageURL, completion: {
                image, errorStr in
                if let image = image, errorStr == nil{
                    DispatchQueue.main.async {
                        let imageURL = self.recipeSearchResults[indexPath.row].imageURL
                        self.recipeImages[imageURL] = image //Cache the image for future use.
                        cell.recipeImage.image = image
                    }
                }
                else{
                    print(errorStr ?? "")
                }
            })
        }
        return cell
    }
    
    //If a row of the table is clicked, segue to a RecipeView representing the cell's recipe.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        performSegue(withIdentifier: "recipeView", sender: index)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue is to the RecipeView, populate the RecipeView's id and image fields using the RecipeSearchResult at the index of the table cell that was clicked.
        if let vc = segue.destination as? RecipeView, let index = sender as? Int
        {
            vc.recipeID = recipeSearchResults[index].id
            if let image = recipeImages[recipeSearchResults[index].imageURL]{
                vc.recipeImage = image
                vc.apiModel = self.apiModel
            }
            
            
        }
    }
    
    
    
    
}

