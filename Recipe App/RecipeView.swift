//
//  RecipeView.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class RecipeView: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeInfoTextField: UITextView!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var instructionsTable: UITableView!
    
    var recipeID:Int = -1 //Unique ID of the recipe in the spoonacular database. Passed in by the previous view controller.
    var recipeImage:UIImage? //The recipe image should be passed in by the previous view controller.
    var recipe:Recipe? //Recipe struct represented by this view controller
    var apiModel:ApiModel? //Used to make calls to the api. Should be passed in by previous view controller.
    
    var ingredients: [String] = [] //List of ingredients
    var instructions:[String] = [] //List of instructions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ingredientsTable.delegate = self
        self.instructionsTable.delegate = self
        self.ingredientsTable.dataSource = self
        self.instructionsTable.dataSource = self
        
        self.recipeInfoTextField.isEditable = false
        
        //Populate the recipe struct using the api. Use the api results to populate the UI.
        if let apiModel = self.apiModel{
            apiModel.getRecipeDetails(recipeId: recipeID, completion: {
                recipe, errorString in
                DispatchQueue.main.async {
                    if errorString == nil, let recipe = recipe{
                        self.recipe = recipe
                        self.recipeNameLabel.text = recipe.title
                        self.recipeInfoTextField.text = self.loadRecipeInfo()
                        
                        for ingredient in recipe.extendedIngredients{
                            self.ingredients.append(ingredient.original)
                        }
                        
                        //Split the instructions list into separate sentences.
                        self.instructions = recipe.instructions.components(separatedBy: ".")
                        
                        //Load the tables using the new data.
                        self.ingredientsTable.reloadData()
                        self.instructionsTable.reloadData()
                    }
                    else{
                        print(errorString ?? "")
                    }
                }
            })
        }
        //If the image was already passed in, populate the image view. Otherwise, load the image using the recipe struct.
        if recipeImage != nil{
            recipeImageView.image = recipeImage
        }
        else if recipe != nil{
            loadImage(imageURL: recipe?.imageURL ?? "", completion: {
                image, errorString in
                if errorString == nil{
                    DispatchQueue.main.async {
                        self.recipeImageView.image = image
                    }
                }
                else{
                    print(errorString ?? "")
                }
            })
        }
        // Do any additional setup after loading the view.
    }
    
    //Populate the UITextView with basic details about the recipe including cooking time, number of servings, and credits.
    func loadRecipeInfo() -> String{
        var recipeInfo:String = ""
        if let readyInMinutes = self.recipe?.readyInMinutes{
            recipeInfo.append("Prep Time: \(readyInMinutes) minutes\n")
        }
        if let servings = self.recipe?.servings{
            recipeInfo.append("\(servings) servings\n")
        }
        if let creditsText = self.recipe?.creditsText{
            recipeInfo.append("By \(creditsText)")
        }
        return recipeInfo
    }
    
    //Determine the size of the ingredients and instructions tables.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.ingredientsTable{
            return ingredients.count
        }
        if tableView == self.instructionsTable{
            return instructions.count
        }
        return 0
    }

    //Use the instructions and ingredients arrays to populate their respective tables.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.ingredientsTable{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell") ?? UITableViewCell(style: .default, reuseIdentifier: "ingredientCell")
            cell.textLabel?.text = ingredients[indexPath.row]
            return cell
        }
        if tableView == self.instructionsTable{
            let cell=tableView.dequeueReusableCell(withIdentifier: "instructionCell") ?? UITableViewCell(style: .default, reuseIdentifier: "instructionCell")
            cell.textLabel?.text = instructions[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }


    @IBAction func onBackButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "recipeSearch", sender: self)
    }
}

