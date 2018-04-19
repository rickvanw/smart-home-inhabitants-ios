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
        
        // Set the navbar currency/unit toggle
        Helper.setCurrencyUnitToggle(viewController: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialize()
    }
    
    // Triggered when currency/unit toggle pressed
    func currencyUnitTogglePressed() {
        
        // TODO: Remove this demo
//        print("currencyUnitTogglePressed")
        self.initialize()
    }
    
    
    func initialize(){
        // TODO: Remove this demo
        
        let kWh = 4.0
        let cubicMeter = 3.0
        
        print("Electrical energy: \(Helper.getCurrencyOrKWhName()) \(Helper.getCurrencyOrKWh(kWh: kWh))")
        print("Gas: \(Helper.getCurrencyOrCubicMeterName()) \(Helper.getCurrencyOrCubicMeter(cubicMeter: cubicMeter))")
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
