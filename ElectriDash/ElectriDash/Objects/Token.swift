//
//  Token.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 10/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class Token: NSObject {

    var sessionId: String
    var username: String
    var name: String
    var surname: String
    var email: String
    var expiresAt: Date
    
    // MARK: Initializer
    
    init?(sessionId: String, username: String, name: String, surname: String, email: String, expiresAt: Date) {
        
        self.sessionId = sessionId
        self.username = username
        self.name = name
        self.surname = surname
        self.email = email
        self.expiresAt = expiresAt
    }
    
}
