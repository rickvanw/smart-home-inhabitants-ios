//
//  DeviceHistory.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 04/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class DeviceHistory: NSObject, Decodable {
    
    var graph: Graph
    
    // MARK: Initializer
    
    init?(graph: Graph) {
        
        self.graph = graph
    }
    
}
