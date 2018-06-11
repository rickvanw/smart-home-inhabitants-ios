//
//  Login.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class Login: NSObject, Decodable{
    
    var token: String
    var houses: [House]
    
    init?(token: String, houses: [House]) {
        
        self.token = token
        self.houses = houses
        
    }
}
