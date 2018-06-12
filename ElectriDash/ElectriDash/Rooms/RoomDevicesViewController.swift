//
//  RoomDevicesViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import Alamofire

class RoomDevicesViewController: UIViewController,UITableViewDataSource, UITableViewDelegate, RoomPageControllerToPage {
    
    var roomId: Int?
    
    var height: CGFloat?
    @IBOutlet weak var deviceTableView: UITableView!
    
    var devices = [Device]()
    
    func reloadPage() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            
            Alamofire.request("\(Constants.Urls.api)/house/\(Helper.getStoredHouseId())/room/\(roomId!)/devices", headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Device info retrieved")
                    do {
                        self.devices = try JSONDecoder().decode([Device].self, from: response.data!)
                        self.devices.sort(by: { $0.categoryName > $1.categoryName })
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return devices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DevicesTableViewCell
        
        // Get the device
        let device: Device
        device = devices[indexPath.row]
        
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
