//
//  Settings.swift
//  Recipe App
//
//  Created by User on 11/18/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class Settings: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func backButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "profile", sender: self)
    }
}

