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
    
    var height: CGFloat?
    @IBOutlet weak var deviceTableView: UITableView!
    
    var devices = [Device]()
    
    func reloadPage() {
        
    }
    
    func setRoom(room: Room) {
        
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
            
            Alamofire.request("\(Constants.Urls.api)house/1/room/1/devices", headers: headers).responseJSON { response in
                switch response.result {
                case .success:
                    print("Device info retrieved")
                    do {
                        self.devices = try JSONDecoder().decode([Device].self, from: response.data!)
                        self.devices.sort(by: { $0.iconName > $1.iconName })
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
            Helper.showAlertOneButton(viewController: self, title: "No internet Connection", message: "Make sure your device is connected to the internet.", buttonTitle: "Ok")
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
        switch device.iconName {
        case "Multi sensor":
            cell.deviceImage.image = UIImage(named: "multisensor")?.withRenderingMode(.alwaysTemplate)
            break
        case "Light":
            cell.deviceImage.image = UIImage(named: "lightbulb")?.withRenderingMode(.alwaysTemplate)
            break
        case "Socket":
            cell.deviceImage.image = UIImage(named: "powerplug")?.withRenderingMode(.alwaysTemplate)
        case "Door sensor":
            cell.deviceImage.image = UIImage(named: "movement")?.withRenderingMode(.alwaysTemplate)
            break
        case "Smart meter":
            cell.deviceImage.image = UIImage(named: "house")?.withRenderingMode(.alwaysTemplate)
            break
        default: break
        }
        
        //Set the tintcolor of the UIImages
        cell.deviceImage.tintColor = UIColor(hexString: "#5ED0A8")
        
        return cell
    }
}
