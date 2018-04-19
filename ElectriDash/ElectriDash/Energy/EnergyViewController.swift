//
//  EnergyViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 18/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class EnergyViewController: UIViewController, CurrencyUnitToggle {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Helper.setCurrencyUnitToggle(viewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func currencyUnitTogglePressed() {
        print("currencyUnitTogglePressed")
        
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
