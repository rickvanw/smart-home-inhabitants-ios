//
//  RoomViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController, PageHeightSetter {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var pageView: UIView!
    @IBOutlet var pageViewHeightConstraint: NSLayoutConstraint!
    
    var room: Room?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: remove dummy room
//        let today = Date()
//        let pastDate = Calendar.current.date(byAdding: .hour, value: -10, to: today)!
//        room = Room(id: 1, name: "Woonkamer", energyUsage: 13, temperature: 22, lastMotion: "Hallo", imageLink: "https://www.woonsquare.nl/wp/wp-content/uploads/2017/06/Scandinavische-woonkamer-inspiratie-1024x640.jpg")
        
        // Set the roomname from the selected room
//        self.title = room?.name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.initialize()
    }
    
    func setCurrencyUnitToggle(viewController: UIViewController){
        
        var imageName = "unit"
        
        if Helper.isCurrency {
            imageName = "euro"
        }
        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate)
        
        let barButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(currencyUnitTogglePressed))
        barButtonItem.tintColor = UIColor.white
        
        viewController.navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    @objc func currencyUnitTogglePressed(){
        
        if Helper.isCurrency {
            Helper.isCurrency = false
        }else{
            Helper.isCurrency = true
        }
        
        self.setCurrencyUnitToggle(viewController: self)
        
        self.initialize()
        
    }
    
    func initialize(){
        
        // Set the navbar currency/unit toggle
        self.setCurrencyUnitToggle(viewController: self)
        
        // TODO: Remove this demo

        let kWh = 4.0
        let cubicMeter = 3.0
        
        print("Electrical energy: \(Helper.getCurrencyOrKWhName()) \(Helper.getCurrencyOrKWh(kWh: kWh))")
        print("Gas: \(Helper.getCurrencyOrCubicMeterName()) \(Helper.getCurrencyOrCubicMeter(cubicMeter: cubicMeter))")
    }
    
    @IBAction func segmentPressed(_ sender: UISegmentedControl) {
        
        if let childVC = self.childViewControllers.first as? SegmentPageChange, room != nil{            
            childVC.pageChangedToIndex(index: sender.selectedSegmentIndex)
        }
    }
    
    func heightConstraint(constant: CGFloat) {
        pageViewHeightConstraint.constant = constant
        
        pageView.needsUpdateConstraints()
    }
    
}
