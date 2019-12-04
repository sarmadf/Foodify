//
//  Storage.swift
//

import Foundation

// Usage:
// UserDefaults.standard.set(object: test, forKey: "test")
// Getting: recipes = Storage.recipes
// Setting: Storage.recipes = recipes

struct Storage {
    static var recipes: [[String: Any]] {
        get {
            return UserDefaults.standard.array(forKey: "recipes") as? [[String : Any]] ?? []
        }
        
        set(recipes) {
            UserDefaults.standard.set(recipes, forKey: "recipes")
        }
    }
    
    static var recentRecipes: [Recipe] {
        get {
            return UserDefaults.standard.array(forKey: "recentRecipes") as? [Recipe] ?? []
        }
        
        set(recentRecipes) {
            UserDefaults.standard.set(recentRecipes, forKey: "recentRecipes")
        }
    }
    
    static var ingredients: [String] {
        get {
            return UserDefaults.standard.array(forKey: "ingredients") as? [String] ?? []
        }
        
        set(ingredients) {
            UserDefaults.standard.set(ingredients, forKey: "ingredients")
        }
    }
    
    static var savedRecipes: [Int] {
        get {
            return UserDefaults.standard.array(forKey: "savedRecipes") as? [Int] ?? []
        }
        
        set(savedRecipes) {
            UserDefaults.standard.set(savedRecipes, forKey: "savedRecipes")
        }
    }
    
    static func addRecentRecipe(recipe: Recipe) {
        var recentRecipeIDs = [Int]()
        for recentRecipe in Storage.recentRecipes {
            recentRecipeIDs.append(recentRecipe.id)
        }
        
        if(recentRecipeIDs.contains(recipe.id) == false) {
            if Storage.recentRecipes.count >= 6 {
                Storage.recentRecipes.removeLast()
            }
            Storage.recentRecipes.insert(recipe, at: 0)
        }
        else {
            if let firstIndex = recentRecipeIDs.firstIndex(of: recipe.id) {
                Storage.recentRecipes.remove(at: firstIndex)
                Storage.recentRecipes.insert(recipe, at: 0)
            }
        }
    }
    
    static func addSavedRecipe(recipeID: Int) {
        Storage.savedRecipes.append(recipeID)
    }
}

func removeIngredients(array: [String]) {
    for str in array {
        Storage.ingredients.removeAll { $0 == str }
    }
}

func addIngredients(array: [String]) {
    for str in array {
        if(Storage.ingredients.contains(str) == false) {
            Storage.ingredients.append(str)
        }
    }
}
