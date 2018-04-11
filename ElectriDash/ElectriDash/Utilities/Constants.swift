//
//  Constants.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

struct Constants {
    
    struct AppColors {
        static let loginBlue = UIColor(red:0.42, green:0.56, blue:0.70, alpha:1.0)
        static let loginGreen = UIColor(red:0.37, green:0.75, blue:0.65, alpha:1.0)
    }
    
    struct Keys {
        static let token = "token"
        static let username = "username"

    }
    
    struct Names {
        static let appName = "EnergyDash"
    }
    
   struct JwtClaimNames
    {
        static let externalSessionId = "externalSessionId"
        static let username = "username"
        static let name = "name"
        static let surname = "surname"
        static let email = "email"
    }
}

