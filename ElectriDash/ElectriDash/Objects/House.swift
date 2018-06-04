//
//  House.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 30/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class House: NSObject, Decodable{

    var name: String
    var id: Int
    var address: String?
    var imageLink: String?
    var serial: String?
    var online: Bool?
    var devices: Int?
    var offlineDevices: Int?
    
    init?(name: String, id: Int, address: String?, imageLink: String?, serial: String?, online: Bool?, devices: Int?, offlineDevices: Int?) {
        
        self.name = name
        self.id = id
        self.address = address
        self.imageLink = imageLink
        self.serial = serial
        self.online = online
        self.devices = devices
        self.offlineDevices = offlineDevices
        
    }
}
