//
//  UIImage + assetIdentifier.swift
//  ElectriDash
//
//  Created by Ruben Assink on 23/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//
import UIKit

enum AssetIdentifier: String {
    case Light = "Search"
    case Multi sensor = "Menu"
}
extension UIImage {
    convenience init?(assetIdentifier: AssetIdentifier) {
        self.init(named: assetIdentifier.rawValue)
    }
}
