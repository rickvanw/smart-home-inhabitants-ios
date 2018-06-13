//
//  RecentRoom.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 13/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RecentRoom: NSObject, NSCoding {
    
    var id: Int
    var name: String
    var imageLink: String

    // MARK: Overrides
    
    // Class will be compaired by id
    override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? RecentRoom{
            return id == object.id
        } else {
            return false
        }
    }
    
    // MARK: Initializer
    
    init?(id: Int, name: String, imageLink: String) {
        
        self.id = id
        self.name = name
        self.imageLink = imageLink
    }
    
    // MARK: NSCoding
    
    struct PropertyKey {
        static let id = "id"
        static let name = "name"
        static let imageLink = "imageLink"
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: PropertyKey.id)
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(imageLink, forKey: PropertyKey.imageLink)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeInteger(forKey: PropertyKey.id)
        let name = aDecoder.decodeObject(forKey: PropertyKey.name) as! String
        let imageLink = aDecoder.decodeObject(forKey: PropertyKey.imageLink) as! String
        
        self.init(id: id, name: name, imageLink: imageLink)
        
    }
    
}
