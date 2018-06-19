//
//  EnergyViewController + TableView.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 19/06/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

extension EnergyViewController: UITableViewDataSource, UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return devices.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "energyDeviceCell", for: indexPath) as! DevicesTableViewCell
        
        // Get the device
        let device: Device
        device = devices[indexPath.row]
        
        // Set the values
        cell.deviceName.text = device.name
        
        if device.energyUsage.usage != nil {
            cell.deviceUsage.text = String(Helper.getCurrencyOrW(energyUsage: device.energyUsage) + " " + Helper.getCurrencyOrWattName())
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DeviceTableToDetail", sender: devices[indexPath.row])

    }
}
