//
//  ApiModel.swift
//  RecipeAppApi
//
//  Created by Ashwin Muralidharan on 11/18/19.
//  Copyright © 2019 Ashwin Muralidharan. All rights reserved.
//

import UIKit
// MARK: - Welcome

//A data model struct for a recipe.
//Utilizes the Codable protocol for easy JSON parsing.
//Utilizes Hashable protocol for storage
struct Recipe: Codable, Hashable {
    let id: Int
    let title: String
    let imageURL: String
    let imageType: String
    let readyInMinutes: Int
    let license, sourceName: String
    let sourceURL: String
    let creditsText: String
    let instructions: String
    let extendedIngredients: [Ingredient]

    enum CodingKeys: String, CodingKey {
        case id, title, imageType, license, sourceName, readyInMinutes
        case sourceURL = "sourceUrl"
        case imageURL = "image"
        case creditsText, instructions, extendedIngredients
    }
    
    /* Hashable functions */
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
        hasher.combine(self.title)
        hasher.combine(self.imageURL)
        hasher.combine(self.imageType)
        hasher.combine(self.readyInMinutes)
        hasher.combine(self.license)
        hasher.combine(self.sourceName)
        hasher.combine(self.sourceURL)
        hasher.combine(self.creditsText)
        hasher.combine(self.instructions)
        hasher.combine(self.extendedIngredients)
    }
}

//A data model struct for a result of the recipe ingredients search api call. Utilizes the Codable protocol for easy JSON parsing.
struct RecipeSearchResult: Codable {
    let id: Int
    let imageURL: String
    let imageType: String
    let missedIngredients: [Ingredient]
    let title: String
    let unusedIngredients: [Ingredient]
    
    enum CodingKeys: String, CodingKey{
        case id, imageType, missedIngredients, title, unusedIngredients
        case imageURL = "image"
    }
}

//A data model struct for an ingredient.
//Utilizes the Codable protocol for easy JSON parsing.
//Utilizes the Hashable protocol for saving
struct Ingredient: Codable, Hashable {
    let amount: Double
    let id: Int
    let name, original: String
    
    /* Hashable functions */
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
         return lhs.id == rhs.id
     }
     
     func hash(into hasher: inout Hasher) {
         hasher.combine(self.id)
         hasher.combine(self.amount)
         hasher.combine(self.id)
         hasher.combine(self.name)
         hasher.combine(self.original)
     }
}

typealias RecipeSearchResults = [RecipeSearchResult]

//A class providing an interface for the spoonacular API. Provides methods for an ingredients-based search and for accessing detailed recipe information. Must be initialized with an API key.
class ApiModel: NSObject {
    var apiKey:String
    
    //Initialize with API key.
    init(apiKey: String){
        self.apiKey = apiKey
    }
    
    //Calls the search by ingredients spoonacular api. Takes in a comma-separated list of ingredients and returns an array of recipe search results.
    func searchRecipes(ingredients:String) -> [RecipeSearchResult]{
        let requestString = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(ingredients)&number=2&apiKey=\(self.apiKey)"
        let session = URLSession.shared
        guard let url = URL(string: requestString) else{
            return []
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        var recipeSearchResults:[RecipeSearchResult] = []
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil{
                print("Couldn't complete the ingredients recipe search GET request.")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                print("Couldn't complete the ingredients recipe search GET request.")
                return
            }
            if !(200...299).contains(httpResponse.statusCode){
                print("Couldn't complete ingredients search GET request. HTTP Code: \(httpResponse.statusCode)")
                return
            }
            if httpResponse.statusCode == 402{
                print("Api quota used up")
                return
            }
            
            do{
                if let data = data{
                    //Decode the JSON into an array of RecipeSearchResult structs using Swift's Codable and Decodable protocols
                    let decoder = JSONDecoder()
                    recipeSearchResults = try decoder.decode(RecipeSearchResults.self, from:data)
                    print(recipeSearchResults[0])
                }
                else{
                    print("Couldn't complete task")
                }
            } catch{
                print("Error: \(error.localizedDescription)")
            }
        })
        task.resume()
        return recipeSearchResults
    }
    
    //Calls the spoonacular Get Recipe Information Api. Takes in a unique recipe id and returns an optional Recipe struct, which will be populated if the call completes successfully
    func getRecipeDetails(recipeId: Int) -> Recipe?{
        let requestString = "https://api.spoonacular.com/recipes/\(recipeId)/information?apiKey=\(self.apiKey)"
        let session = URLSession.shared
        guard let url = URL(string: requestString) else{
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        var recipe:Recipe? = nil
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil{
                print("Couldn't complete the recipe GET request.")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                print("Couldn't complete the recipe GET request.")
                return
            }
            if !(200...299).contains(httpResponse.statusCode){
                print(httpResponse.statusCode)
                return
            }
            if httpResponse.statusCode == 402{
                print("Api quota used up")
                return
            }
            
            do{
                //Decode the JSON into an array of RecipeSearchResult structs using Swift's Codable and Decodable protocols
                if let data = data{
                    let decoder = JSONDecoder()
                    recipe = try decoder.decode(Recipe.self, from:data)
                    print(recipe)
                }
                else{
                    print("Couldn't complete task")
                    print(recipe)
                }
            } catch{
                print("Error: \(error.localizedDescription)")
            }
        })
        task.resume()
        return recipe
        
    }
    
    

}
