//
//  RoomPageControllerToPage.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

protocol RoomPageControllerToPage {
    
    var roomId: Int? { get set }
    func reloadPage()

}
