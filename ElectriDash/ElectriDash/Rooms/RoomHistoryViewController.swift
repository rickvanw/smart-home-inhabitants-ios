//
//  RoomHistoryViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RoomHistoryViewController: UIViewController, RoomPageControllerToPage {
    func setRoom(room: Room) {
        
    }
    
    
    var height:CGFloat?
    var room: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        height = 2000
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
