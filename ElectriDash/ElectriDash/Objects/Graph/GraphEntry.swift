//
//  GraphEntries.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 30/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class GraphEntry: NSObject, Decodable{
    
    var xAxis: String
    var yAxis: Double
    
    // MARK: Initializer
    
    init?(xAxis: String, yAxis: Double?) {
        
        self.xAxis = xAxis
        
        if yAxis != nil{
            self.yAxis = yAxis!
        }else{
            self.yAxis = 0.0
        }
    }

}
