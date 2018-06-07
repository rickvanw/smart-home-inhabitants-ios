//
//  RoomOverviewViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit
import Alamofire

class RoomOverviewViewController: UIViewController, RoomPageControllerToPage {
    
    var roomId: Int?
    var room: Room?
    
    var activityView = UIActivityIndicatorView()
    
    @IBOutlet var roomImageView: UIImageView!
    @IBOutlet var roomNameLabel: UILabel!
    @IBOutlet var roomTotalEnergyLabel: UILabel!
    @IBOutlet var roomTemperatureLabel: UILabel!
    @IBOutlet var roomLastMovementLabel: UILabel!
    @IBOutlet var roomLuminanceLabel: UILabel!
    @IBOutlet var roomAmountOfDevices: UILabel!
    @IBOutlet var roomOnlineOfflineDevices: UILabel!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var luminanceImageVIew: UIImageView!
    @IBOutlet var movementImageView: UIImageView!
    @IBOutlet var temperatureImageView: UIImageView!
    @IBOutlet var totalEnergyImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        scrollView.alpha = 0
        
        self.initialize()

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadPage() {
        initialize()
    }
    
    func initialize(){
        luminanceImageVIew.image = UIImage(named: "lightbulb")?.withRenderingMode(.alwaysTemplate)
        movementImageView.image = UIImage(named: "movement")?.withRenderingMode(.alwaysTemplate)
        temperatureImageView.image = UIImage(named: "thermometer")?.withRenderingMode(.alwaysTemplate)
        totalEnergyImageView.image = UIImage(named: "powerplug")?.withRenderingMode(.alwaysTemplate)
        
        if room != nil{

            setRoomToView()

        }else if roomId != nil{
            getData()
            
        }
    }
    
    func getData() {

        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + Helper.getStoredTokenString()!,
            "Accept": "application/json"
        ]
        
        Alamofire.request("\(Constants.Urls.api)/house/\(Helper.getStoredHouseId())/room/\(roomId!)", headers: headers).responseJSON { response in
                        
            switch response.result {
            case .success:
                print("Rooms info retrieved")
                do {
                    self.room = try JSONDecoder().decode(Room.self, from: response.data!)
                    self.setRoomToView()
                }catch {
                    print("Parse error")
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setRoomToView(){
        if roomImageView.image == nil {
            roomImageView.downloadedFrom(link: room!.imageLink)
        }
        
        roomNameLabel.text = room!.name
        
        if room!.devices != nil{
            if room!.devices == 1{
                roomAmountOfDevices.text = "\(room!.devices!) Apparaat"
            }else{
                roomAmountOfDevices.text = "\(room!.devices!) Apparaten"
                
            }
        }else{
            roomAmountOfDevices.text = "-- Apparaten"
        }
        
        if room!.offlineDevices != nil, room!.devices != nil{
            
            let online = room!.devices! - room!.offlineDevices!
            let offline = room!.offlineDevices!

            roomOnlineOfflineDevices.text = "\(online) online / \(offline) offline"
            
        }else{
            roomOnlineOfflineDevices.text = "-- online / -- offline"
        }
        
        if room!.luminance != nil {
            roomLuminanceLabel.text = "\(room!.luminance!) lux"
        }else{
            roomLuminanceLabel.text = "-- lux"
        }
        
        if room!.luminance != nil {
            roomLuminanceLabel.text = "\(room!.luminance!) lux"
        }else{
            roomLuminanceLabel.text = "-- lux"
        }
        
        
        roomTotalEnergyLabel.text = "\(Helper.getCurrencyOrKWh(energyUsage: room!.energyUsage)) \(Helper.getCurrencyOrKWhName())"
        
        if room!.temperature != nil {
            roomTemperatureLabel.text = "\(room!.temperature!) °C"
        }else{
            roomTemperatureLabel.text = "-- °C"
        }
        
        if room!.getLastMotionDate() != nil{
            let beginDate = room!.getLastMotionDate()!
            let endDate = Date()
            let showDate = Helper.getFormattedTimeStringBetweenDates(beginDate: beginDate, endDate: endDate)
            roomLastMovementLabel.text = "\(showDate)"

        }else{
            roomLastMovementLabel.text = "--"
        }
        
//        scrollView.alpha = 1

        
    }
}
