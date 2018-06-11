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
    
    func getxAxisDate() -> Date?{
        
        var date: Date?
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let newDate = dateFormatter.date(from: xAxis) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        date = newDate
        
        return date
        
    }

}
