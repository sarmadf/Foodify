//
//  RecipeSearchResultTableViewCell.swift
//  Recipe App
//
//  Created by Ashwin Muralidharan on 12/2/19.
//  Copyright © 2019 ECS 189E Group 11. All rights reserved.
//

import UIKit

class RecipeSearchResultTableViewCell: UITableViewCell {
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var missingIngredientsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
