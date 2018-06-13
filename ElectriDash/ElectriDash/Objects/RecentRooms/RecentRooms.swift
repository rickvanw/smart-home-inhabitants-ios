//
//  RecentRooms.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 13/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RecentRooms: NSObject, NSCoding {

    var username: String
    var houseId: Int
    var recentRooms: [RecentRoom]
    
    // MARK: Overrides
    
    // Class will be compaired by id
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? RecentRooms{
            return username == object.username && houseId == object.houseId
        } else {
            return false
        }
    }
    
    // MARK: Initializer
    
    init?(username: String, houseId: Int, recentRooms: [RecentRoom]) {
        
        self.username = username
        self.houseId = houseId
        self.recentRooms = recentRooms
    }
    
    // MARK: NSCoding
    
    struct PropertyKey {
        static let username = "username"
        static let houseId = "houseId"
        static let recentRooms = "recentRooms"
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(username, forKey: PropertyKey.username)
        aCoder.encode(houseId, forKey: PropertyKey.houseId)
        aCoder.encode(recentRooms, forKey: PropertyKey.recentRooms)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let username = aDecoder.decodeObject(forKey: PropertyKey.username) as! String
        let houseId = aDecoder.decodeInteger(forKey: PropertyKey.houseId)
        let recentRooms = aDecoder.decodeObject(forKey: PropertyKey.recentRooms) as! [RecentRoom]
        
        self.init(username: username, houseId: houseId, recentRooms: recentRooms)
        
    }
    
}
