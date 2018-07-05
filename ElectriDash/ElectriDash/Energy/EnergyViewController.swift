//
//  EnergyViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 18/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import Alamofire

class EnergyViewController: UIViewController, TableViewCategory {
    
    @IBOutlet weak var energyDevicesTableview: UITableView!
    var devices = [Device]()
    var allDevices = [Device]()

    var categories = [String:String]()
    var currentCategory: String?
    
    let devCats = Constants.deviceCategories.self

    var categoryButtonShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories["all"] = "Alle apparaten"
        categories[devCats.light] = "Lampen"
        categories[devCats.doorSensor] = "Deursensoren"
        categories[devCats.socket] = "Stopcontacten"
        categories[devCats.multiSensor] = "Multi-sensoren"
        
        energyDevicesTableview.delegate = self
        energyDevicesTableview.dataSource = self
        
        energyDevicesTableview.tableFooterView = UIView()
        getData()
        
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
    
    // MARK: TableViewCategory
    func setCategory() {

        let alert = UIAlertController(title: "Selecteer een categorie", message: nil, preferredStyle: .actionSheet)
        
        alert.view.tintColor = Constants.AppColors.loginGreen
        
        let sortedCategories = categories.sorted {$0.value < $1.value}
        
        for category in sortedCategories{
            
            alert.addAction(UIAlertAction(title: "\(category.value)", style: .default , handler:{ (UIAlertAction)in
                self.currentCategory = category.key
                
                if self.currentCategory == "all"{
                    self.devices = self.allDevices
                }else{
                    self.devices = self.allDevices.filter { $0.categoryName == self.currentCategory }
                }
                
                self.energyDevicesTableview.reloadData()
                
                if let cell = self.energyDevicesTableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? CategoryButtonTableViewCell{
                    cell.categoryButton.setTitle(category.value, for: .normal)
                }
            }))
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Annuleer", style: .cancel) { action -> Void in }
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController, let cell = self.energyDevicesTableview.cellForRow(at: IndexPath(row: 0, section: 0)) as? CategoryButtonTableViewCell{
            let button = cell.categoryButton!
            popoverController.sourceView = button
            popoverController.sourceRect = CGRect(x: button.bounds.midX, y: button.bounds.maxY, width: 0, height: 0)
            popoverController.permittedArrowDirections = .up
            
        }
        
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
                        self.allDevices = self.devices
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



