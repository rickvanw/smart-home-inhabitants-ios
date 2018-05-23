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
    var luminance: Double
    var imageLink: String
    var devices: Int?
    
    // MARK: Initializer
    
    init?(id: Int, name: String, energyUsage: EnergyUsage, temperature: Double, lastMotion: String, luminance: Double, imageLink: String, devices: Int?) {
        
        self.id = id
        self.name = name
        self.energyUsage = energyUsage
        self.temperature = temperature
        self.lastMotion = lastMotion
        self.luminance = luminance
        self.imageLink = imageLink
        
        if devices != nil {
            self.devices = devices
        }
    }
    
    func getLastMotionDate() -> Date{
        
        print("lastMotion: \(lastMotion)")
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: lastMotion) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
        
        return date
        
    }
}
