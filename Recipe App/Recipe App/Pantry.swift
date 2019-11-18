//
//  Pantry.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class Pantry: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func searchButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "recipeSearch", sender: self)
    }
    
    @IBAction func toolBarSearchButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "homeScreen", sender: self)
    }
    
    @IBAction func toolBarProfileButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func toolBarPantryButtonDown(_ sender: Any) {
        // Do nothing, already in target VC
    }
}

