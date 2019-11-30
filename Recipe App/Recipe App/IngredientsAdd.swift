//
//  IngredientsAdd.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class IngredientsAddViewController: UIViewController {

    @IBOutlet weak var ingredientsTextField: UITextField!
    var apiModel:ApiModel = ApiModel.init(apiKey: "6096f60da29649f4baa452b3c0746b7c")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Loaded view")
        // Do any additional setup after loading the view.
    }

    @IBAction func submitButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "recipeSearch", sender: self)
        
    }
    
    @IBAction func backButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? RecipesViewController, let ingredientsList = ingredientsTextField.text
        {
            vc.ingredientsList = ingredientsList
            vc.apiModel = self.apiModel
        }
    }

}
