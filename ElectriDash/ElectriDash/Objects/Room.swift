//
//  Room.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class Room: NSObject {

    var id: Int
    var name: String
    var energyUsage: Double
    var temperature: Double
    var lastMotion: Date
    var imageLink: String
    
    // MARK: Initializer
    
    init?(id: Int, name: String, energyUsage: Double, temperature: Double, lastMotion: Date, imageLink: String) {
        
        self.id = id
        self.name = name
        self.energyUsage = energyUsage
        self.temperature = temperature
        self.lastMotion = lastMotion
        self.imageLink = imageLink
    }
    
}
