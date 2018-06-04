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
        //        public int Id { get; set; }
        //        public string Name { get; set; }
        //        public EnergyUsageEuroDto EnergyUsage { get; set; }
        //        public decimal? Temperature { get; set; }
        //        public DateTime? LastMotion { get; set; }
        //        public decimal? Luminance { get; set; }
        //        public string ImageLink { get; set; }
        //        public int? Devices { get; set; }
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
