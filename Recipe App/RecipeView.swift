//
//  RecipeView.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class RecipeView: UIViewController {

    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeInfoTextField: UITextView!
    @IBOutlet weak var ingredientsTable: UITableView!
    @IBOutlet weak var instructionsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func onBackButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "recipeSearch", sender: self)
    }
}

