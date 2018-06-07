//
//  RoomHistory.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RoomHistory: NSObject, Decodable {

    var graph: Graph
    var devices: Int?
    
    // MARK: Initializer
    
    init?(graph: Graph, devices: Int?) {
        
        self.graph = graph
        self.devices = devices
    }
    
}
