//
//  OverviewViewController.swift
//  ElectriDash
//
//  Created by Ruben Assink on 11/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class OverviewViewController: UIViewController, CurrencyUnitToggle {

    // Outlets
    @IBOutlet weak var labelKwh: UILabel!
    @IBOutlet weak var labelCelsius: UILabel!
    @IBOutlet weak var labelM3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Set the navbar currency/unit toggle
        Helper.setCurrencyUnitToggle(viewController: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Triggered when currency/unit toggle pressed
    func currencyUnitTogglePressed() {
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
