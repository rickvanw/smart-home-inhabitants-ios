//
//  EnergyViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 18/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class EnergyViewController: UIViewController, CurrencyUnitToggle, PageHeightSetter {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var pageView: UIView!
    @IBOutlet var pageViewHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
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
        self.initialize()
    }
    
    func initialize(){
        
        // Set the navbar currency/unit toggle
        Helper.setCurrencyUnitToggle(viewController: self)
        
        // TODO: Remove this demo

        let kWh = 4.0
        let cubicMeter = 3.0
        
//        print("Electrical energy: \(Helper.getCurrencyOrKWhName()) \(Helper.getCurrencyOrKWh(kWh: kWh))")
        print("Gas: \(Helper.getCurrencyOrCubicMeterName()) \(Helper.getCurrencyOrCubicMeter(cubicMeter: cubicMeter))")
    }

    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        
        if let childVC = self.childViewControllers.first as? SegmentPageChange{
            childVC.pageChangedToIndex(index: sender.selectedSegmentIndex)
        }
    }
    
    func heightConstraint(constant: CGFloat) {
        pageViewHeightConstraint.constant = constant
        
        pageView.needsUpdateConstraints()
    }

}



