//
//  HomeScreen.swift
//  Recipe App
//
//  Created by User on 11/17/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class HomeScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var recentlyViewed: UICollectionView!
    var apiModel:ApiModel? = ApiModel.init(apiKey: "9f62f1b5be9d400a9a271f671170ebc1")//Model used to call the api
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if let bannerURL = URL(string: "https://truffle-assets.imgix.net/pxqrocxwsjcc_3NgchLQ5ck4sUQoK60eAGM_matcha-gold-crepe-cakes_landscapeThumbnail_en.png") {
            image.af_setImage(withURL: bannerURL)
        }
        
        
        recentlyViewed.dataSource = self
        recentlyViewed.delegate = self
        recentlyViewed.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(Storage.recentRecipes.count, 6)
    }
    
    // Fixes size of cell
    func collectionView(_ collectionView: UICollectionView,
                                layout collectionViewLayout: UICollectionViewLayout,
                                sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = 80.0
        let height = 80.0
        return CGSize(width: CGFloat(width), height: CGFloat(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = "cell"
        let cell : RecentRecipeCell = collectionView.dequeueReusableCell(withReuseIdentifier:cellName, for:indexPath) as? RecentRecipeCell ?? RecentRecipeCell()
        cell.viewController = self
        cell.isHidden = true
        
        let index = indexPath.row
        if index < Storage.recentRecipes.count {
            //Search for recipes that contain the ingredients specified in ingredientsList.
            if let apiModel = self.apiModel{
                apiModel.getRecipeDetails(recipeId: Storage.recentRecipes[index], completion: { (recipe, string) in
                    cell.setRecipe(recipe: recipe)
                })
            }
        }
        return cell
    }
    
    
    /* Navigation bar methods*/
    @IBAction func pantryButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
    
    @IBAction func searchIngredientsButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "searchIngredients", sender: self)
    }
    
    @IBAction func toolBarSearchButtonPressed(_ sender: Any) {
        // Already on search destination!
        // Possibly go to ingredient lookup?
    }
    
    @IBAction func toolBarProfileButtonPressed(_ sender: Any) {
        //performSegue(withIdentifier: "profile", sender: self)
        performSegue(withIdentifier: "savedRecipes", sender: self)
    }
    
    @IBAction func toolBarPantryButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the segue is to the RecipeView, populate the RecipeView's id and image fields using the RecipeSearchResult at the index of the table cell that was clicked.
        if let cell = sender as? RecentRecipeCell {
            if let vc = segue.destination as? RecipeView, let recipe = cell.recipe
            {
                vc.apiModel = self.apiModel
                vc.recipeID = recipe.id
                vc.recipeImage = cell.recipeImage
            }
        }
    }
}

class RecentRecipeCell: UICollectionViewCell {
    @IBOutlet weak var ImageButton: UIButton!
    
    var viewController : HomeScreen = HomeScreen()
    var recipe : Recipe?
    var recipeImage : UIImage = UIImage()
    
    func setRecipe(recipe : Recipe?) -> Void {
        self.recipe = recipe
        
        if let recipeObject = recipe {
            loadImage(imageURL: recipeObject.imageURL, completion: { imageOptional, string in
                if let image = imageOptional {
                    DispatchQueue.main.async {
                        self.recipeImage = image
                        self.ImageButton.setImage(image, for: .normal)
                        self.isHidden = false
                    }
                }
            })
        }
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        viewController.performSegue(withIdentifier: "recipeView", sender: self)
    }
}



