//
//  DevicesTableViewCell.swift
//  ElectriDash
//
//  Created by Ruben Assink on 23/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class DevicesTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceImage: UIImageView!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceUsage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
