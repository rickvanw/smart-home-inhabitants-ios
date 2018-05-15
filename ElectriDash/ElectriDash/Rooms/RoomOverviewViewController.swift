//
//  RoomOverviewViewController.swift
//  ElectriDash
//
//  Created by Rick van Weersel on 25/04/2018.
//  Copyright © 2018 Rick van Weersel. All rights reserved.
//

import UIKit

class RoomOverviewViewController: UIViewController, RoomPageControllerToPage {
    
    var height: CGFloat?
    var room: Room?
    
    @IBOutlet var roomImageView: UIImageView!
    @IBOutlet var roomNameLabel: UILabel!
    @IBOutlet var roomTotalEnergyLabel: UILabel!
    @IBOutlet var roomTemperatureLabel: UILabel!
    @IBOutlet var roomLastMovementLabel: UILabel!
    
    @IBOutlet var movementImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        height = self.view.frame.height
        
        //        print("\(height)")
        
        self.initialize()
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(){
        movementImageView.image = UIImage(named: "movement")?.withRenderingMode(.alwaysTemplate)
        
        if room != nil{
            
            // TODO: set uiimage name
            roomImageView.downloadedFrom(link: room!.imageLink)

            roomNameLabel.text = room!.name
            roomTotalEnergyLabel.text = "\(room!.energyUsage) kWh"
            roomTemperatureLabel.text = "\(room!.temperature) °C"
            
            let beginDate = room!.getLastMotionDate()
            
            let endDate = Date()
            //            let calendar = Calendar.current
            //            let day = calendar.component(.day, from: currentDate)
            //            let hour = calendar.component(.hour, from: currentDate)
            //            let minutes = calendar.component(.minute, from: currentDate)
            
            //            var showDate = "\(minutes) minuten geleden"
            
            let showDate = Helper.getFormattedTimeStringBetweenDates(beginDate: beginDate, endDate: endDate)
            
            roomLastMovementLabel.text = "\(showDate)"
            
        }
    }
    
    func setRoom(room: Room) {
        self.room = room
        self.initialize()
    }
    
}
