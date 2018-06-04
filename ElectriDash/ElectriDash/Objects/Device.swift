//
//  Device.swift
//  ElectriDash
//
//  Created by Ruben Assink on 22/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class Device: NSObject, Decodable {
    
    var iconName: String
    var name: String
    var id: Int
    var energyUsage: EnergyUsage
    
    // MARK: Initializer
    
    init?(iconName: String, name: String, id: Int, energyUsage: EnergyUsage) {
        
        self.iconName = iconName
        self.name = name
        self.id = id
        self.energyUsage = energyUsage
    }
}
