//
//  PeriodSettingDelegate.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 28/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

protocol PeriodSettingDelegate {
    
    // Add the provided contact
    func newPeriod(from: Date, to: Date)

    // When dismissed, notify to remove the blur
    func canceledModal()
    
}

