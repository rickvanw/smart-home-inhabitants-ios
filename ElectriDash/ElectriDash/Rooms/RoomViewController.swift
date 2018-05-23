//
//  RoomViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import Alamofire

class RoomViewController: UIViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var pageView: UIView!
    
    var roomId: Int?
    
    var selectedIndex = 0
    
    private lazy var roomOverviewViewController: RoomOverviewViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RoomOverviewViewController") as! RoomOverviewViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var roomDevicesViewController: RoomDevicesViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RoomDevicesViewController") as! RoomDevicesViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var roomHistoryViewController: RoomHistoryViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "RoomHistoryViewController") as! RoomHistoryViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()

        // TODO: remove dummy room
//        let today = Date()
//        let pastDate = Calendar.current.date(byAdding: .hour, value: -10, to: today)!
//        room = Room(id: 1, name: "Woonkamer", energyUsage: 13, temperature: 22, lastMotion: "Hallo", imageLink: "https://www.woonsquare.nl/wp/wp-content/uploads/2017/06/Scandinavische-woonkamer-inspiratie-1024x640.jpg")
        
        // Set the roomname from the selected room
//        self.title = room?.name
        
    }
    
  
    
    private func setupView() {
        setupSegmentedControl()
        
        updateView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
            var child = viewController as! RoomPageControllerToPage
            child.roomId = roomId
            
            // Add Child View Controller
            addChildViewController(viewController)
            
            // Add Child View as Subview
            pageView.addSubview(viewController.view)
            
            // Configure Child View
            viewController.view.frame = pageView.bounds
            viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            // Notify Child View Controller
            viewController.didMove(toParentViewController: self)
            
            self.view.layoutIfNeeded()
    
    }
    
    private func setupSegmentedControl() {
        // Configure Segmented Control

        segmentedControl.addTarget(self, action: #selector(selectionDidChange(_:)), for: .valueChanged)
        
        // Select First Segment
        segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func selectionDidChange(_ sender: UISegmentedControl) {
        updateView()
    }
    
    private func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParentViewController: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParentViewController()
    }
    
    private func updateView() {
        if selectedIndex == 0 {
            remove(asChildViewController: roomOverviewViewController)
        }else if selectedIndex == 1 {
            remove(asChildViewController: roomDevicesViewController)
        }else{
            remove(asChildViewController: roomHistoryViewController)
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            selectedIndex = 0
            add(asChildViewController: roomOverviewViewController)
        } else if segmentedControl.selectedSegmentIndex == 1{
            selectedIndex = 1
            add(asChildViewController: roomDevicesViewController)
        }else{
            selectedIndex = 2
            add(asChildViewController: roomHistoryViewController)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.initialize()

    }
    
    func setCurrencyUnitToggle(viewController: UIViewController){
        
        var imageName = "euro"
        
        if Helper.isCurrency {
            imageName = "unit"
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
        
        let child = self.childViewControllers.first as! RoomPageControllerToPage
        child.reloadPage()
    }
    
    func initialize(){
        
        // Set the navbar currency/unit toggle
        self.setCurrencyUnitToggle(viewController: self)
        self.view.layoutIfNeeded()
        // TODO: Remove this demo

//        let kWh = 4.0
//        let cubicMeter = 3.0
//        
////        print("Electrical energy: \(Helper.getCurrencyOrKWhName()) \(Helper.getCurrencyOrKWh(kWh: kWh))")
//        print("Gas: \(Helper.getCurrencyOrCubicMeterName()) \(Helper.getCurrencyOrCubicMeter(cubicMeter: cubicMeter))")
    }
    
}
