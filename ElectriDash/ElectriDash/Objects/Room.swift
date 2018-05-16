//
//  Room.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class Room: NSObject, Decodable {

    var id: Int
    var name: String
    var energyUsage: EnergyUsage
    var temperature: Double
    var lastMotion: String
//    var lastMotionDate: Date
    var imageLink: String
    
    // MARK: Initializer
    
    init?(id: Int, name: String, energyUsage: EnergyUsage, temperature: Double, lastMotion: String, imageLink: String) {
        
        self.id = id
        self.name = name
        self.energyUsage = energyUsage
        self.temperature = temperature
        self.lastMotion = lastMotion
        self.imageLink = imageLink
        
    }
    
    
    func getLastMotionDate() -> Date{
        
        print("lastMotion: \(lastMotion)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: lastMotion) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
 
//        print("currentDate: \(dateFormatter.string(from: Date()))")
//        print("lastMotionDate: \(dateFormatter.string(from: date))")
//

        return date
    }
}
