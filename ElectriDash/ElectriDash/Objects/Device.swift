//
//  Device.swift
//  ElectriDash
//
//  Created by Ruben Assink on 22/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class Device: NSObject, Decodable {
    
    var categoryName: String
    var name: String
    var id: Int
    var energyUsage: EnergyUsage
    
    // MARK: Initializer
    
    init?(categoryName: String, name: String, id: Int, energyUsage: EnergyUsage) {
        
        self.categoryName = categoryName
        self.name = name
        self.id = id
        self.energyUsage = energyUsage
    }
}
