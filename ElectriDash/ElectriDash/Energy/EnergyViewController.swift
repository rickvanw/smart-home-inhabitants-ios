//
//  EnergyViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 18/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class EnergyViewController: UIViewController {

    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var pageView: UIView!
    
    var selectedIndex = 0
    
    private lazy var energyOverviewViewController: EnergyOverviewViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "EnergyOverviewViewController") as! EnergyOverviewViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var energyDevicesViewController: EnergyDevicesViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "EnergyDevicesViewController") as! EnergyDevicesViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    private lazy var energyHistoryViewController: EnergyHistoryViewController = {
        // Load Storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        // Instantiate View Controller
        var viewController = storyboard.instantiateViewController(withIdentifier: "EnergyHistoryViewController") as! EnergyHistoryViewController
        
        // Add View Controller as Child View Controller
        self.add(asChildViewController: viewController)
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()

    }
    
    private func setupView() {
        setupSegmentedControl()
        
        updateView()
    }
    
    private func add(asChildViewController viewController: UIViewController) {
        
        //ADDED***********************************
        var child = viewController as! EnergyPageControllerToPage

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
            remove(asChildViewController: energyOverviewViewController)
        }else if selectedIndex == 1 {
            remove(asChildViewController: energyDevicesViewController)
        }else{
            remove(asChildViewController: energyHistoryViewController)
        }
        
        if segmentedControl.selectedSegmentIndex == 0 {
            selectedIndex = 0
            add(asChildViewController: energyOverviewViewController)
        } else if segmentedControl.selectedSegmentIndex == 1{
            selectedIndex = 1
            add(asChildViewController: energyDevicesViewController)
        }else{
            selectedIndex = 2
            add(asChildViewController: energyHistoryViewController)
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
        
        let child = self.childViewControllers.first as! EnergyPageControllerToPage
        child.reloadPage()
    }

    func initialize(){
        
        // Set the navbar currency/unit toggle
        self.setCurrencyUnitToggle(viewController: self)
        self.view.layoutIfNeeded()

    }

}



