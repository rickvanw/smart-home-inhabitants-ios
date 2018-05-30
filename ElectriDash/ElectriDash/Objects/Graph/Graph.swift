//
//  Graph.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 30/05/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class Graph: NSObject, Decodable{
    
    var graphEntries: GraphEntry
    
    // MARK: Initializer
    
    init?(graphEntries: GraphEntry) {
        
        self.graphEntries = graphEntries

    }
    
}
