//
//  PantryViewCell.swift
//  Recipe App
//
//  Created by Aaron Junghae Kim on 11/16/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class PantryViewCell: UITableViewCell {
    @IBOutlet weak var NameField: UITextView!
    var tapGesture = UITapGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func rename(_ sender: Any) {
        self.NameField.isUserInteractionEnabled = true
        self.NameField.becomeFirstResponder()
         
    }
    
    @objc func dismissKeyboard() {
        self.NameField.resignFirstResponder()
        self.NameField.isUserInteractionEnabled = false
    }
}
