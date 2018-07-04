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
    var temperature: Double?
    var lastMotion: String?
    var luminance: Double?
    var imageLink: String
    var devices: Int?
    var offlineDevices: Int?
    
    // MARK: Overrides
    
    // Class will be compaired by id
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Room{
            return id == object.id
        } else {
            return false
        }
    }
    
    // MARK: Initializer
    
    init?(id: Int, name: String, energyUsage: EnergyUsage, temperature: Double?, lastMotion: String?, luminance: Double?, imageLink: String, devices: Int?, offlineDevices: Int?) {
        
        self.id = id
        self.name = name
        self.energyUsage = energyUsage
        
        if temperature != nil {
            self.temperature = temperature
        }
        
        if lastMotion != nil {
            self.lastMotion = lastMotion
        }
        
        if luminance != nil {
            self.luminance = luminance
        }
        
        self.imageLink = imageLink
        
        if devices != nil {
            self.devices = devices
        }
        
        if offlineDevices != nil {
            self.offlineDevices = offlineDevices
        }
    }
    
    func getLastMotionDate() -> Date?{
        
        var date: Date?
        
        if lastMotion != nil {
            
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            guard let newDate = dateFormatter.date(from: lastMotion!) else {
            fatalError("ERROR: Date conversion failed due to mismatched format.")
        }
            date = newDate
        }
        return date

    }
}
