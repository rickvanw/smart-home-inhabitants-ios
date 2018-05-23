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
   
    @IBOutlet weak var deviceTableView: UITableView!
    
    var devices = [Device]()
    
    func reloadPage() {
        
    }
    
    func setRoom(room: Room) {
        
    }
    
    
    var height:CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceTableView.tableFooterView = UIView()
        getData()
        
        height = 2000
        // Do any additional setup after loading the view.
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
    
    //the method returning size of the list
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return devices.count
    }
    
    //the method returning each cell of the list
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "deviceCell", for: indexPath) as! DevicesTableViewCell
        
        //getting the Device for the specified position
        let device: Device
        device = devices[indexPath.row]
        
        //displaying values
        cell.deviceName.text = device.name
        
        return cell
    }
    
}
