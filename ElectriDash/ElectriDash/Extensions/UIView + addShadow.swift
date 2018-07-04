//
//  UIView + addShadow.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 5
        clipsToBounds = false
    }
}

