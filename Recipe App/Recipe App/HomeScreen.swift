//
//  HomeScreen.swift
//  Recipe App
//
//  Created by User on 11/17/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func pantryButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "pantry", sender: self)
    }
}

