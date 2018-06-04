//
//  EnergyUsage.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 16/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class EnergyUsage: NSObject, Decodable {

    var usage: Double?
    var euro: Double?
    
    init?(usage: Double?, euro: Double?) {
        
        if usage != nil{
            self.usage = usage
        }
        
        if euro != nil{
            self.euro = euro
        }
    }
}
