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
    
    static var recentRecipes: [Int] {
        get {
            return UserDefaults.standard.array(forKey: "recentRecipes") as? [Int] ?? []
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

func addRecentRecipe(id: Int) {
    if(Storage.recentRecipes.contains(id) == false) {
        while Storage.recentRecipes.count >= 6 {
            Storage.recentRecipes.removeLast()
        }
        Storage.recentRecipes.insert(id, at: 0)
    }
    else {
        if let firstIndex = Storage.recentRecipes.firstIndex(of: id) {
            Storage.recentRecipes.remove(at: firstIndex)
            Storage.recentRecipes.insert(id, at: 0)
        }
    }
}

func addSavedRecipe(recipeID: Int) {
    Storage.savedRecipes.append(recipeID)
}
