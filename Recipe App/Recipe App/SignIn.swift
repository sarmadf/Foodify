//
//  SignIn.swift
//  Recipe App
//
//  Created by User on 11/18/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class SignIn: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backButtonDown(_ sender: Any) {
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func signInButtonDown(_ sender: Any) {
        // TODO: Do log in stuff
        
        performSegue(withIdentifier: "profile", sender: self)
    }
    
    @IBAction func forgotPasswordButtonDown(_ sender: Any) {
        // TODO
    }
    
    @IBAction func registerButtonDown(_ sender: Any) {
        // TODO
    }
}


