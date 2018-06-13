//
//  RoomDevicesViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import Alamofire

class RoomDevicesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, RoomPageControllerToPage, TableViewCategory {
    
    var roomId: Int?
    
    var height: CGFloat?
    @IBOutlet weak var deviceTableView: UITableView!
    
    var devices = [Device]()
    var allDevices = [Device]()
    
    var categories = [String:String]()
    var currentCategory: String?
    
    let devCats = Constants.deviceCategories.self
    
    func reloadPage() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories["all"] = "Alle apparaten"
        categories[devCats.light] = "Lampen"
        categories[devCats.doorSensor] = "Deursensoren"
        categories[devCats.socket] = "Stopcontacten"
        categories[devCats.multiSensor] = "Multi-sensoren"
        
        deviceTableView.tableFooterView = UIView()
        getData()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getData() {
    
        if Helper.isConnectedToInternet() {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer " + Helper.getStoredTokenString()!,
                "Accept": "application/json"
            ]
            
            Alamofire.request("\(Constants.Urls.api)/house/\(Helper.getStoredHouseId()!)/room/\(roomId!)/devices", headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Device info retrieved for roomId: \(self.roomId!)")
                    do {
                        self.devices = try JSONDecoder().decode([Device].self, from: response.data!)
                        self.devices.sort(by: { $0.categoryName > $1.categoryName })
                        self.allDevices = self.devices

                        self.deviceTableView.reloadData()
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
    
    // MARK: TableViewCategory
    func setCategory() {
        
        showCategories()
    }


    func showCategories() {
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
                
                self.deviceTableView.reloadData()
                
                if let cell = self.deviceTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CategoryButtonTableViewCell{
                    cell.categoryButton.setTitle(category.value, for: .normal)
                }
                
            }))
            
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Annuleer", style: .cancel) { action -> Void in }
        alert.addAction(cancelAction)
        
        if let popoverController = alert.popoverPresentationController, let cell = self.deviceTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? CategoryButtonTableViewCell{
            let button = cell.categoryButton!
            popoverController.sourceView = button
            popoverController.sourceRect = CGRect(x: button.bounds.midX, y: self.view.bounds.maxX, width: 0, height: 0)
//            popoverController.permittedArrowDirections = []
        }
        
        self.present(alert, animated: true, completion: nil)
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return devices.count + 1
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryButtonCell", for: indexPath) as! CategoryButtonTableViewCell
            
            cell.parentView = self
            
            return cell
            
        }else{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DevicesTableViewCell
        
        // Get the device
        let device: Device
        device = devices[indexPath.row - 1]
        
        // Set the values
        cell.deviceName.text = device.name
        
        if device.energyUsage.usage != nil {
            cell.deviceUsage.text = String(device.energyUsage.usage!) + " W"
        }
        
        // Set the image according to the given iconName
        switch device.categoryName {
        case Constants.deviceCategories.multiSensor:
            cell.deviceImage.image = UIImage(named: "multisensor")?.withRenderingMode(.alwaysTemplate)
            break
        case Constants.deviceCategories.light:
            cell.deviceImage.image = UIImage(named: "lightbulb")?.withRenderingMode(.alwaysTemplate)
            break
        case Constants.deviceCategories.socket:
            cell.deviceImage.image = UIImage(named: "powerplug")?.withRenderingMode(.alwaysTemplate)
            break
        case Constants.deviceCategories.doorSensor:
            cell.deviceImage.image = UIImage(named: "movement")?.withRenderingMode(.alwaysTemplate)
            break
        default: break
        }
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
        //Set the icon tintcolor
        cell.deviceImage.tintColor = UIColor(hexString: "#5ED0A8")

        return cell
        }
    }
}
