//
//  ApiModel.swift
//  RecipeAppApi
//
//  Created by Ashwin Muralidharan on 11/18/19.
//  Copyright © 2019 Ashwin Muralidharan. All rights reserved.
//

import UIKit
// MARK: - Welcome

//A data model struct for a recipe. Utilizes the Codable protocol for easy JSON parsing.
struct Recipe: Codable {
    let id: Int
    let title: String
    let imageURL: String
    let imageType: String
    let servings, readyInMinutes: Int
    let license, sourceName: String
    let sourceURL: String
    let creditsText: String
    let instructions: String
    let extendedIngredients: [Ingredient]

    enum CodingKeys: String, CodingKey {
        case id, title, imageType, license, sourceName, readyInMinutes, servings
        case sourceURL = "sourceUrl"
        case imageURL = "image"
        case creditsText, instructions, extendedIngredients
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

//A data model struct for an ingredient. Utilizes the Codable protocol for easy JSON parsing.
struct Ingredient: Codable {
    let amount: Double
    let id: Int
    let name, original: String
}

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
                completion(nil, "Couldn't complete the ingredients recipe search GET request.")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else{
                completion(nil, "Couldn't complete the ingredients recipe search GET request.")
                return
            }
            if !(200...299).contains(httpResponse.statusCode){
                completion(nil, "Couldn't complete ingredients search GET request. HTTP Code: \(httpResponse.statusCode)")
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
            print(image)
            completion(image, nil)
        }
        else{
            completion(nil, "Couldn't the image request")
        }
    })
    task.resume()
}
