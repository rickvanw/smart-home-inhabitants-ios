//
//  Constants.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//
//  Energy prices obtained on 19/04/2018 https://www.milieucentraal.nl/energie-besparen/snel-besparen/grip-op-je-energierekening/energieprijzen/

import UIKit

struct Constants {
    
    struct AppColors {
        static let loginBlue = UIColor(red:0.42, green:0.56, blue:0.70, alpha:1.0)
        static let loginGreen = UIColor(red:0.37, green:0.75, blue:0.65, alpha:1.0)
    }
    
    struct Keys {
        static let token = "token"
        static let username = "username"
        static let currencyUnit = "currencyUnit"
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
    
    struct Prices
    {
        static let cubicMeter = 0.20
        static let kWh = 0.63
    }
    
    struct Units
    {
        static let euro = "€"
        static let kWh = "kWh"
        static let cubicMeter = "m³"
    }
}

