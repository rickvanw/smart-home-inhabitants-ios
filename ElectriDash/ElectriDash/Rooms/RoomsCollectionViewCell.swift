//
//  CollectionViewCell.swift
//  ElectriDash
//
//  Created by Ruben Assink on 26/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RoomsCollectionViewCell: UICollectionViewCell {
    
    // Mark: outlets
    @IBOutlet weak var locationImage: UIImageView!
    @IBOutlet weak var roomName: UILabel!
    @IBOutlet weak var roomKwh: UILabel!
    @IBOutlet weak var roomTemp: UILabel!
    @IBOutlet weak var roomLastMotion: UILabel!
    
    
}
