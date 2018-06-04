//
//  EnergyDevicesViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 23/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class EnergyDevicesViewController: UIViewController, EnergyPageControllerToPage {
    func reloadPage() {
        
    }
    
    
    var categories = [String]()
    var currentCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let devCats = Constants.deviceCategories.self
        
        categories.append(devCats.light)
        categories.append(devCats.doorSensor)
        categories.append(devCats.socket)
        categories.append(devCats.multiSensor)
        
        showCategories()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCategories() {
        let alert = UIAlertController(title: "Selecteer een categorie", message: nil, preferredStyle: .actionSheet)
        
        
        
        for category in categories{
            
            alert.addAction(UIAlertAction(title: "\(category)", style: .default , handler:{ (UIAlertAction)in
                self.currentCategory = category
            }))
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in }
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
