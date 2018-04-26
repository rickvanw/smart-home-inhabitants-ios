//
//  EnergyDevicesViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 23/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class EnergyDevicesViewController: UIViewController, EnergyPageControllerToPage {

    var height:CGFloat?
    
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
