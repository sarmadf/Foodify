//
//  IngredientsAdd.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class IngredientsAdd: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "recipeSearch", sender: self)
    }
    
    @IBAction func backButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
}

