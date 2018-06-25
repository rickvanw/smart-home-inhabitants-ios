//
//  EnergyViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 18/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import Alamofire

class EnergyViewController: UIViewController {
    
    @IBOutlet weak var energyDevicesTableview: UITableView!
    var devices = [Device]()
    var categories = [String]()
    var currentCategory: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        energyDevicesTableview.delegate = self
        energyDevicesTableview.dataSource = self
        
        let devCats = Constants.deviceCategories.self
        
        categories.append(devCats.light)
        categories.append(devCats.doorSensor)
        categories.append(devCats.socket)
        categories.append(devCats.multiSensor)
        
        energyDevicesTableview.tableFooterView = UIView()
        getData()
        //        showCategories()
        
        // Do any additional setup after loading the view.
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
        
        self.reloadPage()
    }

    func initialize(){
        
        // Set the navbar currency/unit toggle
        self.setCurrencyUnitToggle(viewController: self)
        self.view.layoutIfNeeded()

    }
    
    
    func reloadPage() {
        energyDevicesTableview.reloadData()
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
    
    //Tableview
    func getData() {
        if Helper.isConnectedToInternet() {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Helper.getStoredTokenString()!,
                "Accept": "application/json"
            ]
            
            Alamofire.request("\(Constants.Urls.api)/house/\(Helper.getStoredHouseId()!)/devices", headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Device info retrieved")
                    do {
                        self.devices = try JSONDecoder().decode([Device].self, from: response.data!)
                        self.devices.sort(by: { $0.categoryName > $1.categoryName })
                        self.energyDevicesTableview.reloadData()
                    }catch {
                        print("Parse error")
                        
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        else {
            Helper.showAlertOneButton(viewController: self, title: "Geen netwerkverbinding", message: "Controleer of uw apparaat verbonden is met het internet", buttonTitle: "OK")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "DeviceTableToDetail" {
            
            let targetController = segue.destination as! EnergyDeviceDetailViewController
            
            if let device = sender as? Device{
                
                targetController.deviceId = device.id
                targetController.title = device.name
            }
        }
    }

}



