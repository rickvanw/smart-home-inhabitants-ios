//
//  CategoryButtonTableViewCell.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 11/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class CategoryButtonTableViewCell: UITableViewCell {

    @IBOutlet var categoryButton: CustomButton!
    weak var parentView: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func categoryButtonPressed(_ sender: CustomButton) {
        (parentView as! TableViewCategory).setCategory()
    }
    

}
