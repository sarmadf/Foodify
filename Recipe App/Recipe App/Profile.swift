//
//  Profile.swift
//  Recipe App
//
//  Created by User on 11/11/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class Profile: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Should change text of sign in/logout button based on if a user is logged in
    }
    
    
    @IBAction func signInButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "signIn", sender: self)
    }
    
    @IBAction func savedRecipesButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "savedRecipes", sender: self)
    }
    
    @IBAction func settingsButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: self)
    }
    
    @IBAction func toolBarSearchButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "homeScreen", sender: self)
    }
    
    @IBAction func toolBarProfileButtonDown(_ sender: Any) {
        // Do nothing, already in target VC
    }
    
    @IBAction func toolBarPantryButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
}

