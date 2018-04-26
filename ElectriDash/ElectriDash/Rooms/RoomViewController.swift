//
//  RoomViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController, CurrencyUnitToggle, PageHeightSetter {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var pageView: UIView!
    @IBOutlet var pageViewHeightConstraint: NSLayoutConstraint!
    
    var room: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: remove dummy room
        let today = Date()
        let pastDate = Calendar.current.date(byAdding: .hour, value: -10, to: today)!
        room = Room(id: 1, name: "Woonkamer", energyUsage: 13, temperature: 22, lastMotion: pastDate, imageLink: "https://www.woonsquare.nl/wp/wp-content/uploads/2017/06/Scandinavische-woonkamer-inspiratie-1024x640.jpg")
        
        // Set the navbar currency/unit toggle
        Helper.setCurrencyUnitToggle(viewController: self)
        
        // Set the roomname from the selected room
        self.title = room?.name
        
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
        // TODO: Remove this demo
        
        let kWh = 4.0
        let cubicMeter = 3.0
        
        print("Electrical energy: \(Helper.getCurrencyOrKWhName()) \(Helper.getCurrencyOrKWh(kWh: kWh))")
        print("Gas: \(Helper.getCurrencyOrCubicMeterName()) \(Helper.getCurrencyOrCubicMeter(cubicMeter: cubicMeter))")
    }
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        
        if var childVC = self.childViewControllers.first as? SegmentPageChange, room != nil{            
            childVC.pageChangedToIndex(index: sender.selectedSegmentIndex)
        }
    }
    
    func heightConstraint(constant: CGFloat) {
        pageViewHeightConstraint.constant = constant
        
        pageView.needsUpdateConstraints()
    }
    
}
