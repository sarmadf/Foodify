//
//  HomeScreen.swift
//  Recipe App
//
//  Created by User on 11/17/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var recentlyViewed: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        recentlyViewed.dataSource = self
        recentlyViewed.delegate = self
        recentlyViewed.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(Storage.recentRecipes.count, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellName = "cell"
        let cell : RecentRecipeCell = collectionView.dequeueReusableCell(withReuseIdentifier:cellName, for:indexPath) as? RecentRecipeCell ?? RecentRecipeCell()
        
        let index = indexPath.row
        if index < Storage.recentRecipes.count {
            cell.recipe = Storage.recentRecipes[index]
        }
        return cell
    }
    
    
    /* Navigation bar methods*/
    @IBAction func pantryButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
    
    @IBAction func toolBarSearchButtonPressed(_ sender: Any) {
        // Already on search destination!
        // Possibly go to ingredient lookup?
    }
    
    @IBAction func toolBarProfileButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func toolBarPantryButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
}

class RecentRecipeCell: UICollectionViewCell {
    @IBOutlet weak var ImageButton: UIButton!
    
    var recipe : Recipe = Recipe(id: -1, title: "nil", imageURL: "nil", imageType: "nil", readyInMinutes: -1, license: "nil", sourceName: "nil", sourceURL: "nil", creditsText: "nil", instructions: "nil", extendedIngredients: [])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let url = URL(string: recipe.imageURL) else { return }
        //guard let url = URL(string: "https://hips.hearstapps.com/hmg-prod.s3.amazonaws.com/images/20190725-delish-air-fryer-burger-ehg-vertical-2-1565299632.png?crop=1.00xw:0.667xh;0,0.193xh&resize=480:*") else { return }
        let session = URLSession(configuration: .default)
        let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                return
            }
            else {
                if (response as? HTTPURLResponse) != nil {
                    if let imageData = data {
                        DispatchQueue.main.async { // Must be called on main thread
                            let image = UIImage(data: imageData)
                            self.ImageButton.setImage(image, for: .normal)
                            self.ImageButton.contentVerticalAlignment = .fill
                            self.ImageButton.contentHorizontalAlignment = .fill
                            self.ImageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                        }
                    }
                }
            }
        }
        
        downloadPicTask.resume()
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
    }
}



