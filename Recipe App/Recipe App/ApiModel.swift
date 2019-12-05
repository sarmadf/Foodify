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
    let servings, readyInMinutes: Int
    let sourceName: String
    let sourceURL: String
    let creditsText: String
    let instructions: String
    let extendedIngredients: [Ingredient]

    enum CodingKeys: String, CodingKey {
        case id, title, imageType, sourceName, readyInMinutes, servings
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
        hasher.combine(self.sourceName)
        hasher.combine(self.sourceURL)
        hasher.combine(self.creditsText)
        hasher.combine(self.instructions)
        hasher.combine(self.extendedIngredients)
        hasher.combine(self.servings)
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

struct IngredientSearchResult: Codable {
    let image, name: String
}
typealias IngredientSearchResults = [IngredientSearchResult]

typealias RecipeSearchResults = [RecipeSearchResult]

//A class providing an interface for the spoonacular API. Provides methods for an ingredients-based search and for accessing detailed recipe information. Must be initialized with an API key.
class ApiModel: NSObject {
    var apiKey:String
    
    //Initialize with API key.
    init(apiKey: String){
        self.apiKey = apiKey
    }
    
    
    func searchRecipes(ingredients:String, completion: @escaping ([RecipeSearchResult]?, String?) -> Void){
        let requestString = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(ingredients)&number=2&apiKey=\(self.apiKey)"
        let session = URLSession.shared
        guard let url = URL(string: requestString) else{
            completion(nil, "URL invalid")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")

        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in

            if error != nil{
                completion(nil, "Couldn't complete the ingredients recipe search GET request.")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else{
                completion(nil, "Couldn't complete the ingredients recipe search GET request.")
                return
            }
            
            if !(200...299).contains(httpResponse.statusCode){
                completion(nil, "Couldn't complete ingredients search GET request. HTTP Code: \(httpResponse.statusCode)")
                print("\(httpResponse.statusCode)")
                return
            }
            
            if httpResponse.statusCode == 402{
                completion(nil, "Api quota used up")
                return
            }
            
            do{
                if let data = data{
                    //Decode the JSON into an array of RecipeSearchResult structs using Swift's Codable and Decodable protocols
                    let decoder = JSONDecoder()
                    let recipeSearchResults = try decoder.decode(RecipeSearchResults.self, from:data)
                    completion(recipeSearchResults, nil)
                }
                else{
                    completion(nil, "Couldn't complete task")
                }
            } catch{
                completion(nil, "Error: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
    
    
    func getRecipeDetails(recipeId: Int, completion: @escaping (Recipe?, String?) -> Void){
        let requestString = "https://api.spoonacular.com/recipes/\(recipeId)/information?apiKey=\(self.apiKey)"
        let session = URLSession.shared
        guard let url = URL(string: requestString) else{
            completion(nil, "URL invalid")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil{
                completion(nil, "Couldn't complete the recipe details GET request.")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                completion(nil, "Couldn't complete the recipe details GET request.")
                return
            }
            if !(200...299).contains(httpResponse.statusCode){
                completion(nil, "Couldn't complete recipe details GET request. HTTP Code: \(httpResponse.statusCode)")
                return
            }
            if httpResponse.statusCode == 402{
                completion(nil, "Api quota used up")
                return
            }
            
            do{
                //Decode the JSON into an array of RecipeSearchResult structs using Swift's Codable and Decodable protocols
                if let data = data{
                    let decoder = JSONDecoder()
                    let recipe = try decoder.decode(Recipe.self, from:data)
                    completion(recipe, nil)
                }
                else{
                    completion(nil, "Couldn't complete task")
                }
            } catch{
                completion(nil, "Error: \(error.localizedDescription)")
            }
        })
        task.resume()
        
    }
    
    func autocompleteIngredients(ingredient: String, completion: @escaping (String?, String?) -> Void){
        let requestString = "https://api.spoonacular.com/food/ingredients/autocomplete?query=\(ingredient)&number=1&apiKey=\(self.apiKey)"
        let session = URLSession.shared
        guard let url = URL(string: requestString) else{
            completion(nil, "URL invalid")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
            if error != nil{
                completion(nil, "Couldn't complete the autocomplete ingredients GET request.")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                completion(nil, "Couldn't complete the autocomplete ingredients GET request.")
                return
            }
            if !(200...299).contains(httpResponse.statusCode){
                completion(nil, "Couldn't complete autocomplete ingredients GET request. HTTP Code: \(httpResponse.statusCode)")
                return
            }
            if httpResponse.statusCode == 402{
                completion(nil, "Api quota used up")
                return
            }
            
            do{
                //Decode the JSON into an array of RecipeSearchResult structs using Swift's Codable and Decodable protocols
                if let data = data{
                    let decoder = JSONDecoder()
                    let ingredientSearchResults = try decoder.decode(IngredientSearchResults.self, from: data)
                    if ingredientSearchResults.count > 0{
                        completion(ingredientSearchResults[0].name, nil)
                    }
                    else{
                        completion(nil, nil)
                    }
                }
                else{
                    completion(nil, "Couldn't complete task")
                }
            } catch{
                completion(nil, "Error: \(error.localizedDescription)")
            }
        })
        task.resume()
    }
}

func loadImage(imageURL: String, completion: @escaping (UIImage?, String?) -> Void ){
    guard let url = URL(string: imageURL) else{
        completion(nil, "URL invalid")
        return
    }
    let urlRequest = URLRequest(url: url)
    let session = URLSession.shared
    let task = session.dataTask(with: urlRequest, completionHandler: { data, response, error in
        if error != nil{
            completion(nil, "Couldn't complete the image request.")
            return
        }
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else{
            completion(nil, "Couldn't complete the image request.")
            return
        }
        if let data = data{
            let image = UIImage(data: data)
            completion(image, nil)
        }
        else{
            completion(nil, "Couldn't the image request")
        }
    })
    task.resume()
}
